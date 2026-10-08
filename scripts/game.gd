# Autoload "Game": dados globais, salvamento e teclas.
extends Node

const SAVE_PATH := "user://save_mnemos.json"

var zone_index := 0
var max_hearts := 3
var hearts := 3
var items := {}        # nome do item -> true (ex.: "seda")
var flags := {}        # chave -> true (baús, inimigos e chefes derrotados, etc.)
var active_ally := ""  # id do ajudante ativo (só um por vez)
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
	return true


# Carrega PNG em tempo de execução (não precisa do importador do editor).
func load_tex(path: String) -> Texture2D:
	if _tex_cache.has(path):
		return _tex_cache[path]
	var img := Image.load_from_file(path)
	if img == null:
		push_error("Imagem não encontrada: " + path)
		return null
	var tex := ImageTexture.create_from_image(img)
	_tex_cache[path] = tex
	return tex
