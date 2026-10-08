# Inimigo comum: persegue, avisa com um piscar (telegraph), dá um bote e pode ser morto.
extends Node2D

var world: Node2D = null
var player: Node2D = null
var key := ""
var hp := 2
var speed := 28.0
var state := 0          # 0 = perseguir, 1 = avisar, 2 = bote
var timer := 0.0
var cool := 0.0
var lunge_dir := Vector2.ZERO
var knock := Vector2.ZERO
var flash := 0.0
var dead := false
var sprite: Sprite2D = null

const HALF := 4.0


func setup(w: Node2D, p: Node2D, k: String, sprite_path: String, vida: int, vel: float) -> void:
	world = w
	player = p
	key = k
	hp = vida
	speed = vel
	sprite = Sprite2D.new()
	sprite.texture = Game.load_tex(sprite_path)
	add_child(sprite)
	add_to_group("hurtable")


func _process(delta: float) -> void:
	if dead or player == null:
		return
	cool = max(0.0, cool - delta)
	flash = max(0.0, flash - delta)
	var para_jogador := player.position - position
	var dist := para_jogador.length()

	if state == 0:
		if dist < 90.0 and dist > 0.5:
			if dist < 30.0 and cool <= 0.0:
				state = 1
				timer = 0.5
				lunge_dir = para_jogador.normalized()
			else:
				_move(para_jogador.normalized() * speed * delta)
	elif state == 1:
		timer -= delta
		if timer <= 0.0:
			state = 2
			timer = 0.22
	elif state == 2:
		timer -= delta
		_move(lunge_dir * 120.0 * delta)
		if timer <= 0.0:
			state = 0
			cool = 1.2

	if knock.length() > 0.01:
		_move(knock * delta)
		knock = knock.move_toward(Vector2.ZERO, 300.0 * delta)

	if dist < 8.0:
		player.take_damage(1, position)

	if flash > 0.0:
		modulate = Color(1, 0.5, 0.5)
	elif state == 1:
		modulate = Color(1, 1, 1) if int(timer * 12.0) % 2 == 0 else Color(1, 0.6, 0.3)
	else:
		modulate = Color(1, 1, 1)


func _move(d: Vector2) -> void:
	var nx := position + Vector2(d.x, 0.0)
	if world.can_stand(nx, HALF):
		position = nx
	var ny := position + Vector2(0.0, d.y)
	if world.can_stand(ny, HALF):
		position = ny


func take_hit(dmg: int, from_pos: Vector2) -> void:
	if dead:
		return
	hp -= dmg
	flash = 0.12
	knock = (position - from_pos).normalized() * 60.0
	if hp <= 0:
		die()


func die() -> void:
	dead = true
	Game.set_flag(key)
	remove_from_group("hurtable")
	queue_free()
