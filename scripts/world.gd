# Mundo de um degrau: guarda o mapa em texto, desenha os tiles e diz o que é passável.
extends Node2D

const TS := 16
const GATE_KEY := {"~": "seda", "X": "mandibula", "h": "faro", "Y": "salto", "E": "escalada", "I": "garras"}

var rows: Array = []
var width := 0
var height := 0
var gate := ""
var unlocked := {}   # itens obtidos + "porta" quando o chefe cai
var tex_atlas: Texture2D = null


func _ready() -> void:
	tex_atlas = Game.load_tex("res://assets/sprites/tiles/tiles.png")


# Recebe as linhas do mapa e o caractere do portão do degrau.
func load_map(src_rows: Array, gate_char: String) -> void:
	gate = gate_char if gate_char != "" else "#"
	rows.clear()
	width = 0
	for r in src_rows:
		width = max(width, str(r).length())
	for r in src_rows:
		var s := str(r)
		while s.length() < width:
			s += "#"
		rows.append(s.replace("G", gate))
	height = rows.size()
	queue_redraw()


func char_at(x: int, y: int) -> String:
	if y < 0 or y >= height or x < 0 or x >= width:
		return "#"
	return rows[y].substr(x, 1)


func walkable_char(ch: String) -> bool:
	if ch == "#":
		return false
	if GATE_KEY.has(ch):
		return unlocked.has(GATE_KEY[ch])
	if ch == "N":
		return unlocked.has("porta")
	return true


func world_to_cell(p: Vector2) -> Vector2i:
	return Vector2i(int(floor(p.x / TS)), int(floor(p.y / TS)))


# Um personagem é uma caixa de lado 2*half centrada em p.
func can_stand(p: Vector2, half: float) -> bool:
	var pontos := [Vector2(-half, -half), Vector2(half, -half), Vector2(-half, half), Vector2(half, half)]
	for o in pontos:
		var c := world_to_cell(p + o)
		if not walkable_char(char_at(c.x, c.y)):
			return false
	return true


# Acha a primeira célula com o caractere dado; devolve (-1,-1) se não existir.
func find_char(ch: String) -> Vector2i:
	for y in range(height):
		for x in range(width):
			if char_at(x, y) == ch:
				return Vector2i(x, y)
	return Vector2i(-1, -1)


func cell_center(c: Vector2i) -> Vector2:
	return Vector2(c.x * TS + TS / 2.0, c.y * TS + TS / 2.0)


func tile_index(ch: String) -> int:
	if GATE_KEY.has(ch):
		var aberto := unlocked.has(GATE_KEY[ch])
		match ch:
			"~":
				return 1 if aberto else 3
			"X":
				return 1 if aberto else 4
			"h":
				return 1 if aberto else 2
			"Y":
				return 10 if aberto else 5
			"E":
				return 13 if aberto else 6
			"I":
				return 7 if aberto else 11
	if ch == "N":
		return 12 if unlocked.has("porta") else 8
	if ch == "_" or ch == "M":
		return 9
	if ch == "#":
		return 2
	if ch == ",":
		return 1
	return 0


func _draw() -> void:
	if tex_atlas == null:
		return
	for y in range(height):
		for x in range(width):
			var idx := tile_index(char_at(x, y))
			draw_texture_rect_region(tex_atlas,
				Rect2(x * TS, y * TS, TS, TS),
				Rect2(idx * TS, 0, TS, TS))


func redraw() -> void:
	queue_redraw()
