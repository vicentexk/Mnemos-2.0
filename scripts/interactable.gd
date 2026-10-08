# Coisas que o jogador toca ou fala: baú, coração, ajudante recrutável.
extends Node2D

signal triggered(node)

var kind := "chest"      # chest, heart, npc, save
var key := ""
var main: Node2D = null
var player: Node2D = null
var sprite: Sprite2D = null


func setup(tipo: String, chave: String, m: Node2D, p: Node2D, sprite_path: String) -> void:
	kind = tipo
	key = chave
	main = m
	player = p
	sprite = Sprite2D.new()
	sprite.texture = Game.load_tex(sprite_path)
	add_child(sprite)


# Monólito: aceso quando é o último save.
func set_active(ativo: bool) -> void:
	if sprite != null:
		var caminho := "res://assets/sprites/items/monolith_active.png" if ativo else "res://assets/sprites/items/monolith_dormant.png"
		sprite.texture = Game.load_tex(caminho)


func set_opened() -> void:
	if sprite != null:
		sprite.texture = Game.load_tex("res://assets/sprites/items/chest_open.png")


func _process(_delta: float) -> void:
	# Ajudante e NPC balançam mesmo parados (animação provisória até os quadros da arte).
	if kind == "npc" and sprite != null:
		sprite.position.y = Game.bob_px(3.0)
	if player == null or Game.dialog_open:
		return
	var dist: float = position.distance_to(player.position)
	if kind == "heart" and dist < 10.0:
		triggered.emit(self)
	elif kind != "heart" and dist < 16.0 and Input.is_action_just_pressed("talk"):
		triggered.emit(self)
