# Tudo o que aparece na tela: título, corações, nome da fase, mensagens, diálogos e fim.
extends Control

var mode := "title"          # title, play, ending
var menu: Array = []
var menu_index := 0
var lines: Array = []
var line_index := 0
var zone_name := ""
var hearts := 3
var max_hearts := 3
var message := ""
var message_time := 0.0
var ending_lines: Array = []
var cutscene_lines: Array = []
var cutscene_index := 0
var font: Font = null
var tex_full: Texture2D = null
var tex_empty: Texture2D = null


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	# Fonte: Deltarune (uso provisório, licença não comercial) se estiver no projeto; senão KiwiSoda.
	font = ThemeDB.fallback_font
	for caminho in ["res://assets/fonts/Deltarune.ttf", "res://assets/fonts/KiwiSoda.ttf"]:
		if ResourceLoader.exists(caminho):
			font = load(caminho) as Font
			break
	tex_full = Game.load_tex("res://assets/sprites/ui/heart_full.png")
	tex_empty = Game.load_tex("res://assets/sprites/ui/heart_empty.png")


func _process(delta: float) -> void:
	if message_time > 0.0:
		message_time -= delta
		if message_time <= 0.0:
			message = ""
	queue_redraw()


func show_message(texto: String, tempo := 2.5) -> void:
	message = texto
	message_time = tempo


func show_dialog(novas: Array) -> void:
	lines = novas
	line_index = 0


func has_dialog() -> bool:
	return lines.size() > 0


# Avança para a próxima linha. Devolve false quando o diálogo acabou.
func next_line() -> bool:
	line_index += 1
	if line_index >= lines.size():
		lines = []
		line_index = 0
		return false
	return true


func _draw() -> void:
	if mode == "title":
		_draw_title()
	elif mode == "ending":
		_draw_ending()
	elif mode == "cutscene":
		_draw_cutscene()
	else:
		_draw_play()


func _draw_play() -> void:
	for i in range(max_hearts):
		var tex = tex_full if i < hearts else tex_empty
		if tex != null:
			draw_texture(tex, Vector2(4 + i * 9, 4))
	draw_string(font, Vector2(120, 12), zone_name, HORIZONTAL_ALIGNMENT_RIGHT, 196, 9, Color(1, 1, 1))
	if message != "":
		draw_string(font, Vector2(0, 170), message, HORIZONTAL_ALIGNMENT_CENTER, 320, 9, Color(1, 1, 0.6))
	if lines.size() > 0:
		draw_rect(Rect2(6, 118, 308, 56), Color(0, 0, 0, 0.85))
		draw_rect(Rect2(6, 118, 308, 56), Color(0.9, 0.8, 0.5), false, 1.0)
		draw_string(font, Vector2(14, 132), lines[line_index], HORIZONTAL_ALIGNMENT_LEFT, 292, 9, Color(1, 1, 1))
		var fim := "E ou J: continuar" if line_index == lines.size() - 1 else "E ou J: próxima"
		draw_string(font, Vector2(14, 166), fim, HORIZONTAL_ALIGNMENT_LEFT, 292, 7, Color(0.8, 0.8, 0.6))


func _draw_title() -> void:
	draw_rect(Rect2(0, 0, 320, 180), Color(0.07, 0.11, 0.06))
	draw_string(font, Vector2(0, 58), "MNEMOS 2.0", HORIZONTAL_ALIGNMENT_CENTER, 320, 22, Color(0.9, 1, 0.7))
	draw_string(font, Vector2(0, 76), "a travessia contra a Névoa (título provisório)", HORIZONTAL_ALIGNMENT_CENTER, 320, 8, Color(0.7, 0.8, 0.7))
	for i in range(menu.size()):
		var cor := Color(1, 0.9, 0.4) if i == menu_index else Color(0.75, 0.75, 0.75)
		var prefixo := "> " if i == menu_index else "  "
		draw_string(font, Vector2(0, 116 + i * 14), prefixo + menu[i], HORIZONTAL_ALIGNMENT_CENTER, 320, 10, cor)
	draw_string(font, Vector2(0, 170), "Setas/WASD: andar   J/Z: atacar   K/X/Espaço: esquivar   E/Enter: falar", HORIZONTAL_ALIGNMENT_CENTER, 320, 6, Color(0.6, 0.6, 0.6))


func _draw_cutscene() -> void:
	draw_rect(Rect2(0, 0, 320, 180), Color(0.03, 0.04, 0.06))
	# Faixas de "letterbox" de cinema.
	draw_rect(Rect2(0, 0, 320, 14), Color(0, 0, 0))
	draw_rect(Rect2(0, 166, 320, 14), Color(0, 0, 0))
	if cutscene_index < cutscene_lines.size():
		draw_multiline_string(font, Vector2(24, 62), str(cutscene_lines[cutscene_index]),
			HORIZONTAL_ALIGNMENT_CENTER, 272, 10, -1, Color(0.92, 0.94, 0.85))
	draw_string(font, Vector2(0, 160), "%d / %d" % [cutscene_index + 1, cutscene_lines.size()],
		HORIZONTAL_ALIGNMENT_RIGHT, 300, 7, Color(0.6, 0.6, 0.6))
	draw_string(font, Vector2(0, 176), "E ou J: continuar", HORIZONTAL_ALIGNMENT_CENTER, 320, 7, Color(0.7, 0.7, 0.5))


func _draw_ending() -> void:
	draw_rect(Rect2(0, 0, 320, 180), Color(0.02, 0.02, 0.05))
	var y := 52
	for l in ending_lines:
		draw_string(font, Vector2(0, y), str(l), HORIZONTAL_ALIGNMENT_CENTER, 320, 9, Color(0.95, 0.95, 0.9))
		y += 16
	draw_string(font, Vector2(0, 168), "E ou J: voltar ao menu", HORIZONTAL_ALIGNMENT_CENTER, 320, 7, Color(0.7, 0.7, 0.5))
