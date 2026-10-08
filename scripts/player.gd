# A formiga que o jogador controla: andar, atacar, esquivar e receber dano.
extends Node2D

var world: Node2D = null
var main: Node2D = null
var facing := Vector2(0, 1)
var can_move := true

const SPEED := 62.0
const DODGE_SPEED := 150.0
const HALF := 5.0

var attack_timer := 0.0
var attack_flash := 0.0
var dodge_timer := 0.0
var dodge_cool := 0.0
var invuln := 0.0
var knock := Vector2.ZERO
var sprite: Sprite2D = null


func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.texture = Game.load_tex("res://assets/sprites/player/ant_player.png")
	add_child(sprite)


func _process(delta: float) -> void:
	attack_timer = max(0.0, attack_timer - delta)
	dodge_cool = max(0.0, dodge_cool - delta)
	dodge_timer = max(0.0, dodge_timer - delta)
	invuln = max(0.0, invuln - delta)
	attack_flash = max(0.0, attack_flash - delta)

	var dir := Vector2.ZERO
	if can_move and not Game.dialog_open:
		dir.x = Input.get_axis("move_left", "move_right")
		dir.y = Input.get_axis("move_up", "move_down")
	if dir.length() > 1.0:
		dir = dir.normalized()
	if dir.length() > 0.01:
		facing = dir.normalized()

	if can_move and not Game.dialog_open:
		if Input.is_action_just_pressed("dodge") and dodge_cool <= 0.0:
			dodge_timer = 0.18
			dodge_cool = 0.6
			invuln = 0.25
		if Input.is_action_just_pressed("attack") and attack_timer <= 0.0:
			_attack()

	var spd := SPEED
	var mover := dir
	if dodge_timer > 0.0:
		spd = DODGE_SPEED
		if mover.length() < 0.01:
			mover = facing

	var passo := mover * spd * delta
	_move_axis(Vector2(passo.x, 0.0))
	_move_axis(Vector2(0.0, passo.y))
	if knock.length() > 0.01:
		_move_axis(knock * delta)
		knock = knock.move_toward(Vector2.ZERO, 400.0 * delta)

	if world != null:
		var c = world.world_to_cell(position)
		if world.char_at(c.x, c.y) == "N" and main != null:
			main.on_door_reached()

	sprite.visible = invuln <= 0.0 or int(invuln * 20.0) % 2 == 0
	queue_redraw()


func _move_axis(d: Vector2) -> void:
	var np := position + d
	if world != null and world.can_stand(np, HALF):
		position = np


func _attack() -> void:
	attack_timer = 0.32
	attack_flash = 0.12
	var ponto := position + facing * 12.0
	for n in get_tree().get_nodes_in_group("hurtable"):
		if is_instance_valid(n) and n.global_position.distance_to(ponto) < 15.0:
			n.take_hit(1, position)


func take_damage(amount: int, from_pos: Vector2) -> void:
	if invuln > 0.0 or dodge_timer > 0.0:
		return
	if main == null:
		return
	invuln = 1.0
	knock = (position - from_pos).normalized() * 110.0
	Game.hearts = max(0, Game.hearts - amount)
	main.on_player_hit()


func _draw() -> void:
	if attack_flash > 0.0:
		var a := facing.angle()
		draw_arc(Vector2.ZERO, 12.0, a - 0.9, a + 0.9, 8, Color(1, 1, 0.9, 0.9), 2.0)
