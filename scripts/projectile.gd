# Projétil de chefe: anda em linha reta, some na parede ou depois de um tempo.
extends Node2D

var world: Node2D = null
var player: Node2D = null
var velocidade := Vector2.ZERO
var vida := 3.0


func setup(w: Node2D, p: Node2D, direcao: Vector2, vel: float) -> void:
	world = w
	player = p
	velocidade = direcao.normalized() * vel
	var sprite := Sprite2D.new()
	sprite.texture = Game.load_tex("res://assets/sprites/fx/projectile.png")
	add_child(sprite)


func _process(delta: float) -> void:
	vida -= delta
	if vida <= 0.0:
		queue_free()
		return
	position += velocidade * delta
	if world != null and not world.can_stand(position, 1.0):
		queue_free()
		return
	if player != null and position.distance_to(player.position) < 6.0:
		player.take_damage(1, position)
		queue_free()
