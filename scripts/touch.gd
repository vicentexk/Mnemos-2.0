# Botões de toque (Android). Cada botão aperta a ação correspondente do teclado.
extends Control

# Tamanho mínimo: 44 px lógicos (viewport 320x180 com stretch); equivale a >= 44 dp em celulares comuns.
const BOTOES := [
	["move_up", Rect2(44, 44, 44, 44), "^"],
	["move_left", Rect2(0, 88, 44, 44), "<"],
	["move_right", Rect2(88, 88, 44, 44), ">"],
	["move_down", Rect2(44, 132, 44, 44), "v"],
	["attack", Rect2(262, 120, 52, 52), "ATK"],
	["dodge", Rect2(208, 128, 44, 44), "ESQ"],
	["talk", Rect2(208, 80, 44, 44), "FAL"],
]


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = DisplayServer.is_touchscreen_available() or OS.has_feature("mobile")
	for b in BOTOES:
		var acao: String = b[0]
		var botao := Button.new()
		botao.position = b[1].position
		botao.size = b[1].size
		botao.text = b[2]
		botao.focus_mode = Control.FOCUS_NONE
		botao.button_down.connect(func(): Input.action_press(acao))
		botao.button_up.connect(func(): Input.action_release(acao))
		add_child(botao)
