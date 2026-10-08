# Autoload "Game": dados globais, salvamento e teclas.
extends Node

const SAVE_PATH := "user://save_mnemos.json"

var zone_index := 0
var max_hearts := 3
var hearts := 3
var items := {}        # nome do item -> true (ex.: "seda")
var flags := {}        # chave -> true (baús, inimigos e chefes derrotados, etc.)
var active_ally := ""  # id do ajudante ativo (só um por vez)
# Último monólito tocado (ponto de retorno ao morrer). cp_zone = -1 é "nenhum ainda".
var cp_zone := -1
var cp_pos := Vector2.ZERO
var dialog_open := false

var _tex_cache := {}


func _ready() -> void:
	_bind("move_up", [KEY_W, KEY_UP])
	_bind("move_down", [KEY_S, KEY_DOWN])
	_bind("move_left", [KEY_A, KEY_LEFT])
	_bind("move_right", [KEY_D, KEY_RIGHT])
	_bind("attack", [KEY_J, KEY_Z])
	_bind("dodge", [KEY_K, KEY_X, KEY_SPACE])
	_bind("talk", [KEY_E, KEY_ENTER])


func _bind(action: String, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for k in keys:
		var ev := InputEventKey.new()
		ev.physical_keycode = k
		InputMap.action_add_event(action, ev)


func has_item(nome: String) -> bool:
	return items.has(nome)


func give_item(nome: String) -> void:
	items[nome] = true


func set_flag(chave: String) -> void:
	flags[chave] = true


func has_flag(chave: String) -> bool:
	return flags.has(chave)


func reset_new_game() -> void:
	zone_index = 0
	max_hearts = 3
	hearts = 3
	items = {}
	flags = {}
	active_ally = ""
	cp_zone = -1
	cp_pos = Vector2.ZERO


func set_checkpoint(zona: int, pos: Vector2) -> void:
	cp_zone = zona
	cp_pos = pos


# Oscila entre 0 e -1 pixel inteiro (pixel art não aceita meio pixel).
func bob_px(velocidade: float) -> float:
	var t := Time.get_ticks_msec() / 1000.0
	return -1.0 if int(t * velocidade) % 2 == 1 else 0.0


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func save_game() -> void:
	var data := {
		"zone": zone_index,
		"max_hearts": max_hearts,
		"hearts": hearts,
		"items": items,
		"flags": flags,
		"active_ally": active_ally,
		"cp_zone": cp_zone,
		"cp_x": cp_pos.x,
		"cp_y": cp_pos.y,
	}
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f == null:
		push_error("Não consegui gravar o save em " + SAVE_PATH)
		return
	f.store_string(JSON.stringify(data))
	f.close()


func load_game() -> bool:
	if not has_save():
		return false
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if f == null:
		return false
	var data = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(data) != TYPE_DICTIONARY:
		return false
	zone_index = int(data.get("zone", 0))
	max_hearts = int(data.get("max_hearts", 3))
	hearts = int(data.get("hearts", max_hearts))
	items = data.get("items", {})
	flags = data.get("flags", {})
	active_ally = str(data.get("active_ally", ""))
	cp_zone = int(data.get("cp_zone", -1))
	cp_pos = Vector2(float(data.get("cp_x", 0.0)), float(data.get("cp_y", 0.0)))
	return true


# Carrega PNG em tempo de execução (não precisa do importador do editor).
func load_tex(path: String) -> Texture2D:
	if _tex_cache.has(path):
		return _tex_cache[path]
	var tex: Texture2D = null
	if ResourceLoader.exists(path):
		tex = load(path) as Texture2D
	else:
		# Fallback para arquivos fora do import (ex.: edição sem reimportar).
		var img := Image.load_from_file(path)
		if img != null:
			tex = ImageTexture.create_from_image(img)
	if tex == null:
		push_error("Imagem não encontrada: " + path)
		return null
	_tex_cache[path] = tex
	return tex
