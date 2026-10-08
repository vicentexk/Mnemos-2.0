# Chefe de degrau. Ataques: investida (avisa antes) e anel de projéteis.
# Abaixo de 50% de vida fica mais rápido e atira mais. A Pálida também some e reaparece.
extends Node2D

signal died

var world: Node2D = null
var player: Node2D = null
var main: Node2D = null
var data: Dictionary = {}
var key := ""
var hp := 20
var max_hp := 20
var phase := 1
var awake := false
var state := "espera"   # espera, aviso, investida, descanso
var timer := 1.0
var dash_dir := Vector2.ZERO
var knock := Vector2.ZERO
var flash := 0.0
var teleport_timer := 4.0
var dead := false
var sprite: Sprite2D = null

const HALF := 9.0


func setup(w: Node2D, p: Node2D, m: Node2D, d: Dictionary, sprite_path: String) -> void:
	world = w
	player = p
	main = m
	data = d
	key = str(d["key"])
	max_hp = int(d["hp"])
	hp = max_hp
	sprite = Sprite2D.new()
	sprite.texture = Game.load_tex(sprite_path)
	add_child(sprite)
	add_to_group("hurtable")


func _process(delta: float) -> void:
	if sprite != null:
		sprite.position.y = Game.bob_px(3.0)
	if dead or player == null:
		return
	flash = max(0.0, flash - delta)
	if not awake:
		if position.distance_to(player.position) < 120.0:
			awake = true
		_finish_colors()
		return

	if phase == 1 and hp <= max_hp / 2:
		phase = 2
		if main != null:
			main.show_message("%s está furioso!" % data["name"])

	var vel := float(data["speed"])
	if phase == 2:
		vel *= 1.3

	timer -= delta
	if state == "espera":
		var para := player.position - position
		if para.length() > 14.0:
			_move(para.normalized() * vel * delta)
		if timer <= 0.0:
			if phase == 2 and randf() < 0.5:
				_ring()
				timer = 1.6
			elif float(data["dash"]) > 0.0 and randf() < 0.6:
				state = "aviso"
				timer = 0.8
				dash_dir = (player.position - position).normalized()
			else:
				_ring()
				timer = 1.8
	elif state == "aviso":
		if timer <= 0.0:
			state = "investida"
			timer = 0.4
	elif state == "investida":
		_move(dash_dir * float(data["dash"]) * delta)
		if position.distance_to(player.position) < 11.0:
			player.take_damage(1, position)
		if timer <= 0.0:
			state = "descanso"
			timer = 0.9
	elif state == "descanso":
		if timer <= 0.0:
			state = "espera"
			timer = 0.6

	if data["teleport"] and phase == 2:
		teleport_timer -= delta
		if teleport_timer <= 0.0:
			teleport_timer = 4.0
			_teleport()

	if knock.length() > 0.01:
		_move(knock * delta)
		knock = knock.move_toward(Vector2.ZERO, 300.0 * delta)

	if position.distance_to(player.position) < 9.0:
		player.take_damage(1, position)
	_finish_colors()


func _finish_colors() -> void:
	if flash > 0.0:
		modulate = Color(1, 0.5, 0.5)
	elif state == "aviso":
		modulate = Color(1, 1, 1) if int(timer * 14.0) % 2 == 0 else Color(1, 0.5, 0.2)
	else:
		modulate = Color(1, 1, 1)


func _ring() -> void:
	var n := int(data["ring"])
	if phase == 2:
		n = int(data["phase2_ring"])
	if n <= 0:
		return
	var proj_cena := load("res://scripts/projectile.gd")
	for i in range(n):
		var ang := TAU * float(i) / float(n)
		var p = Node2D.new()
		p.set_script(proj_cena)
		get_parent().add_child(p)
		p.position = position
		p.setup(world, player, Vector2(cos(ang), sin(ang)), 55.0)


func _teleport() -> void:
	var celulas: Array = []
	for y in range(world.height):
		for x in range(world.width):
			if world.walkable_char(world.char_at(x, y)) and world.char_at(x, y) != "N":
				var centro: Vector2 = world.cell_center(Vector2i(x, y))
				if centro.distance_to(player.position) > 70.0:
					celulas.append(centro)
	if celulas.size() > 0:
		position = celulas[randi() % celulas.size()]


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
	awake = true
	hp -= dmg
	flash = 0.1
	knock = (position - from_pos).normalized() * 20.0
	if hp <= 0:
		_die()


func _die() -> void:
	dead = true
	Game.set_flag("chefe_" + key)
	remove_from_group("hurtable")
	died.emit()
	queue_free()
