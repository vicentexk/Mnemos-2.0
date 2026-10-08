# Ajudante ativo: segue a formiga e ataca o inimigo mais próximo de tempos em tempos.
extends Node2D

var player: Node2D = null
var attack_timer := 1.0
var sprite: Sprite2D = null


func setup(p: Node2D, sprite_path: String) -> void:
	player = p
	sprite = Sprite2D.new()
	sprite.texture = Game.load_tex(sprite_path)
	add_child(sprite)


func _process(delta: float) -> void:
	if player == null:
		return
	var alvo := player.position + Vector2(-12.0, 4.0)
	position = position.move_toward(alvo, 70.0 * delta)
	attack_timer -= delta
	if attack_timer <= 0.0:
		var melhor: Node2D = null
		var menor := 40.0
		for n in get_tree().get_nodes_in_group("hurtable"):
			var d: float = n.global_position.distance_to(position)
			if d < menor:
				menor = d
				melhor = n
		if melhor != null:
			melhor.take_hit(1, position)
			attack_timer = 1.2
		else:
			attack_timer = 0.3
