# Coisas que o jogador toca ou fala: baú, coração, ajudante recrutável.
extends Node2D

signal triggered(node)

var kind := "chest"      # chest, heart, npc
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


func set_opened() -> void:
	if sprite != null:
		sprite.texture = Game.load_tex("res://assets/sprites/items/chest_open.png")


func _process(_delta: float) -> void:
	if player == null or Game.dialog_open:
		return
	var dist: float = position.distance_to(player.position)
	if kind == "heart" and dist < 10.0:
		triggered.emit(self)
	elif kind != "heart" and dist < 16.0 and Input.is_action_just_pressed("talk"):
		triggered.emit(self)
