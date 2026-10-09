# Controlador principal: título, carregar degrau, criar inimigos/chefe/baús, diálogos e fim.
extends Node2D

const Zones = preload("res://scripts/zones.gd")
const WorldScript = preload("res://scripts/world.gd")
const PlayerScript = preload("res://scripts/player.gd")
const EnemyScript = preload("res://scripts/enemy.gd")
const BossScript = preload("res://scripts/boss.gd")
const AllyScript = preload("res://scripts/ally.gd")
const InteractableScript = preload("res://scripts/interactable.gd")
const HudScript = preload("res://scripts/hud.gd")
const TouchScript = preload("res://scripts/touch.gd")

var world: Node2D = null
var entities: Node2D = null
var player: Node2D = null
var camera: Camera2D = null
var hud: Control = null
var mode := "title"          # title, play, ending
var zone := 0
var boss_node: Node2D = null
var ally_node: Node2D = null
var dialog_after: Callable = Callable()
var ending_timer := -1.0
var title_index := 0
var menu_actions: Array = []
var pending_spawn := Vector2(-1, -1)   # posição de retorno (monólito) para o próximo _build_zone
var cutscene_index := 0
# Fuga da Névoa: começa quando a dungeon principal do degrau cai. A frente sobe pela esquerda.
var fuga_ativa := false
var fuga_x := 0.0
var fuga_vel := 0.0

# Cutscene inicial do modo história (texto original, pt-BR).
const CUTSCENE := [
	"Muito acima do formigueiro, uma montanha guarda o topo do mundo.",
	"Há algum tempo, uma névoa cinza começou a descer pelas encostas. Onde ela passa, as cores somem.",
	"A colônia precisa de alguém que suba até o topo e descubra de onde a névoa vem.",
	"Você é uma formiga operária. Não é a mais forte, mas é a que mais observa.",
	"Pelo caminho, outras formigas vão se juntar a você, cada uma com um jeito próprio de atravessar o mundo.",
	"Volte ao formigueiro sempre que puder. E lembre: a névoa não espera.",
]


func _ready() -> void:
	print("[main] _ready")
	world = WorldScript.new()
	add_child(world)
	entities = Node2D.new()
	add_child(entities)
	player = PlayerScript.new()
	player.world = world
	player.main = self
	add_child(player)
	camera = Camera2D.new()
	camera.position_smoothing_enabled = true
	player.add_child(camera)
	camera.make_current()

	var tela := CanvasLayer.new()
	add_child(tela)
	hud = HudScript.new()
	tela.add_child(hud)

	print("[main] hud criado: %s" % str(hud != null))
	var toque := CanvasLayer.new()
	add_child(toque)
	toque.add_child(TouchScript.new())

	_open_title()


func _process(delta: float) -> void:
	if hud == null:
		return
	if mode == "title":
		_title_input()
		return
	if mode == "cutscene":
		if Input.is_action_just_pressed("talk") or Input.is_action_just_pressed("attack"):
			cutscene_index += 1
			hud.cutscene_index = cutscene_index
			if cutscene_index >= CUTSCENE.size():
				_start_zone(0)
		return
	if mode == "ending":
		if Input.is_action_just_pressed("talk") or Input.is_action_just_pressed("attack"):
			_open_title()
		return
	if hud.has_dialog():
		if Input.is_action_just_pressed("talk") or Input.is_action_just_pressed("attack"):
			if not hud.next_line():
				_end_dialog()
		return
	if fuga_ativa:
		_atualizar_fuga(delta)
	if ending_timer > 0.0:
		ending_timer -= delta
		if ending_timer <= 0.0:
			_show_ending()


# ---------- título e fim ----------

func _open_title() -> void:
	mode = "title"
	hud.mode = "title"
	hud.lines = []
	Game.dialog_open = false
	_clear_entities()
	world.visible = false
	player.visible = false
	entities.visible = false
	menu_actions = []
	var nomes: Array = []
	if Game.has_save():
		menu_actions.append("continuar")
		nomes.append("CONTINUAR")
	menu_actions.append("novo")
	nomes.append("NOVO JOGO")
	hud.menu = nomes
	title_index = 0
	hud.menu_index = 0


func _title_input() -> void:
	if Input.is_action_just_pressed("move_up"):
		title_index = max(0, title_index - 1)
	if Input.is_action_just_pressed("move_down"):
		title_index = min(menu_actions.size() - 1, title_index + 1)
	hud.menu_index = title_index
	if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("talk"):
		if menu_actions[title_index] == "continuar":
			Game.load_game()
			# Continuar volta ao último monólito tocado (se houver).
			if Game.cp_zone >= 0:
				pending_spawn = Game.cp_pos
				_start_zone(Game.cp_zone)
			else:
				_start_zone(Game.zone_index)
		else:
			Game.reset_new_game()
			_start_cutscene()


func _start_cutscene() -> void:
	mode = "cutscene"
	hud.mode = "cutscene"
	hud.cutscene_lines = CUTSCENE
	hud.cutscene_index = 0
	cutscene_index = 0
	_clear_entities()
	world.visible = false
	player.visible = false
	entities.visible = false


func _show_ending() -> void:
	mode = "ending"
	hud.mode = "ending"
	hud.ending_lines = [
		"A Névoa se desfaz como orvalho ao sol.",
		"A colônia chega ao topo do mundo.",
		"",
		"Fim desta versão de teste.",
		"Próximas etapas: ajudantes, segredos e dungeons opcionais.",
	]
	_clear_entities()
	world.visible = false
	player.visible = false
	entities.visible = false
	Game.save_game()


# ---------- degraus ----------

func _start_zone(i: int) -> void:
	mode = "play"
	_encerrar_fuga()
	hud.menu = []
	hud.mode = "play"
	zone = i
	Game.zone_index = i
	Game.hearts = Game.max_hearts
	world.visible = true
	player.visible = true
	entities.visible = true
	_build_zone()
	hud.hearts = Game.hearts
	hud.max_hearts = Game.max_hearts
	hud.zone_name = str(Zones.DATA[i]["name"])
	Game.save_game()
	var chave_intro := "intro_%d" % i
	if not Game.has_flag(chave_intro):
		Game.set_flag(chave_intro)
		_say(Zones.DATA[i]["intro"])


func _clear_entities() -> void:
	for c in entities.get_children():
		if c.is_in_group("hurtable"):
			c.remove_from_group("hurtable")
		c.queue_free()
	boss_node = null
	ally_node = null


# Paleta por degrau: cada região tem tom próprio (provisório, até a arte final).
const TINTS := [
	Color(1.00, 1.00, 1.00),  # 1 planície: natural
	Color(1.00, 0.88, 0.55),  # 2 duna: areia
	Color(0.70, 0.90, 0.70),  # 3 samambaias: verde úmido
	Color(0.85, 0.70, 1.00),  # 4 névoa roxa
	Color(0.75, 0.90, 1.00),  # 5 gelo azulado
	Color(1.00, 0.70, 0.60),  # 6 terra vermelha
	Color(0.85, 0.85, 0.85),  # 7 Pálida: cinza
]


func _build_zone() -> void:
	_clear_entities()
	var d: Dictionary = Zones.DATA[zone]
	world.tint = TINTS[zone % TINTS.size()]
	var retorno := pending_spawn
	pending_spawn = Vector2(-1, -1)
	world.unlocked = {}
	for k in Game.items.keys():
		world.unlocked[k] = true
	if Game.has_flag("chefe_" + str(d["boss"]["key"])):
		world.unlocked["porta"] = true
	world.load_map(d["map"], str(d["gate"]))

	var ini: Vector2i = world.find_char("P")
	if ini.x >= 0:
		player.position = world.cell_center(ini)
	if retorno.x >= 0.0:
		player.position = retorno
	player.can_move = true

	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = world.width * 16
	camera.limit_bottom = world.height * 16

	for y in range(world.height):
		for x in range(world.width):
			var ch: String = world.char_at(x, y)
			var centro: Vector2 = world.cell_center(Vector2i(x, y))
			if ch == "e":
				_spawn_enemy(x, y, centro)
			elif ch == "M":
				_spawn_boss(centro)
			elif ch == "K":
				_spawn_chest(centro)
			elif ch == "V":
				_spawn_heart(x, y, centro)
			elif ch == "C":
				_spawn_npc(centro)
			elif ch == "S":
				_spawn_save(centro)
	_spawn_ally()


func _spawn_enemy(x: int, y: int, centro: Vector2) -> void:
	var k := "e_%d_%d_%d" % [zone, x, y]
	if Game.has_flag(k):
		return
	var e = EnemyScript.new()
	entities.add_child(e)
	e.position = centro
	e.setup(world, player, k, "res://assets/sprites/enemies/enemy_z%d.png" % zone, 2 + zone / 2, 26.0 + zone * 2.0)


func _spawn_boss(centro: Vector2) -> void:
	var dados: Dictionary = Zones.DATA[zone]["boss"]
	if Game.has_flag("chefe_" + str(dados["key"])):
		return
	var b = BossScript.new()
	entities.add_child(b)
	b.position = centro
	b.setup(world, player, self, dados, "res://assets/sprites/bosses/boss_z%d.png" % zone)
	b.died.connect(_on_boss_died)
	boss_node = b
	hud.show_message(str(Zones.DATA[zone]["boss_intro"][0]), 3.0)


func _spawn_chest(centro: Vector2) -> void:
	var k := "bau_%d" % zone
	var it = InteractableScript.new()
	entities.add_child(it)
	it.position = centro
	it.setup("chest", k, self, player, "res://assets/sprites/items/chest_closed.png")
	if Game.has_flag(k):
		it.set_opened()
	it.triggered.connect(_on_interact)


func _spawn_heart(x: int, y: int, centro: Vector2) -> void:
	var k := "coracao_%d_%d_%d" % [zone, x, y]
	if Game.has_flag(k):
		return
	var it = InteractableScript.new()
	entities.add_child(it)
	it.position = centro
	it.setup("heart", k, self, player, "res://assets/sprites/items/heart_container.png")
	it.triggered.connect(_on_interact)


func _spawn_save(centro: Vector2) -> void:
	var it = InteractableScript.new()
	entities.add_child(it)
	it.position = centro
	it.setup("save", "save_%d" % zone, self, player, "res://assets/sprites/items/monolith_dormant.png")
	# Aceso se for o último monólito salvo (o ponto de retorno fica logo abaixo dele).
	var retorno := centro + Vector2(0, 14)
	if Game.cp_zone == zone and Game.cp_pos.distance_to(retorno) < 1.0:
		it.set_active(true)
	it.triggered.connect(_on_interact)


func _spawn_npc(centro: Vector2) -> void:
	var d: Dictionary = Zones.DATA[zone]
	if str(d["ally_id"]) == "" or Game.has_flag("npc_%d" % zone):
		return
	var it = InteractableScript.new()
	entities.add_child(it)
	it.position = centro
	it.setup("npc", "npc_%d" % zone, self, player, "res://assets/sprites/allies/ally_%s.png" % str(d["ally_id"]))
	it.triggered.connect(_on_interact)


func _spawn_ally() -> void:
	if ally_node != null:
		ally_node.queue_free()
		ally_node = null
	var id := Game.active_ally
	if id == "":
		return
	var a = AllyScript.new()
	entities.add_child(a)
	a.position = player.position
	a.setup(player, "res://assets/sprites/allies/ally_%s.png" % id)
	ally_node = a


# ---------- eventos ----------

func _on_interact(node) -> void:
	var d: Dictionary = Zones.DATA[zone]
	if node.kind == "chest":
		Game.set_flag(node.key)
		node.set_opened()
		if str(d["item"]) != "":
			Game.give_item(str(d["item"]))
			world.unlocked[str(d["item"])] = true
			world.queue_redraw()
			Game.save_game()
			_say(["Você encontrou: %s." % str(d["item_label"]),
				"Agora o caminho à frente pode ser atravessado."])
	elif node.kind == "npc":
		Game.set_flag(node.key)
		Game.active_ally = str(d["ally_id"])
		Game.save_game()
		_say(["%s se junta a você." % str(d["ally_name"]),
			"Ela segue você e ataca inimigos próximos."], Callable(self, "_after_recruit"))
		node.remove_from_group("hurtable")
		node.queue_free()
	elif node.kind == "save":
		var retorno: Vector2 = node.position + Vector2(0, 14)
		Game.set_checkpoint(zone, retorno)
		Game.hearts = Game.max_hearts
		Game.save_game()
		for c in entities.get_children():
			if c.get("kind") == "save":
				c.set_active(c == node)
		hud.hearts = Game.hearts
		show_message("Monólito ativado. Progresso salvo.")
	elif node.kind == "heart":
		Game.max_hearts += 1
		Game.hearts = Game.max_hearts
		Game.set_flag(node.key)
		Game.save_game()
		hud.max_hearts = Game.max_hearts
		hud.hearts = Game.hearts
		hud.show_message("Coração extra! Vida máxima: %d" % Game.max_hearts)
		node.queue_free()


func _after_recruit() -> void:
	_spawn_ally()


func _on_boss_died() -> void:
	boss_node = null
	world.unlocked["porta"] = true
	world.queue_redraw()
	Game.save_game()
	hud.show_message("O chefe caiu! A porta se abriu.", 3.0)
	if zone == Zones.DATA.size() - 1:
		ending_timer = 3.0
	else:
		_iniciar_fuga()


# Velocidade da Névoa cresce a cada degrau (a montanha fica mais difícil).
func _iniciar_fuga() -> void:
	fuga_ativa = true
	fuga_x = 0.0
	fuga_vel = 22.0 + zone * 6.0
	show_message("A Névoa começa a descer! Corra até a porta!", 3.0)


func _encerrar_fuga() -> void:
	fuga_ativa = false
	queue_redraw()


func _atualizar_fuga(delta: float) -> void:
	if mode != "play" or Game.dialog_open:
		return
	fuga_x += fuga_vel * delta
	queue_redraw()
	if player.position.x < fuga_x + 4.0:
		_encerrar_fuga()
		_game_over()


func _draw() -> void:
	if not fuga_ativa:
		return
	# Névoa: faixa da borda esquerda até a frente, com borda mais clara.
	var x0 := -400.0
	draw_rect(Rect2(x0, -400, fuga_x - x0, 1200), Color(0.55, 0.55, 0.62, 0.8))
	draw_rect(Rect2(fuga_x, -400, 6, 1200), Color(0.85, 0.85, 0.9, 0.5))


func on_player_hit() -> void:
	hud.hearts = Game.hearts
	if Game.hearts <= 0:
		_game_over()


# Game over estilo Zelda: volta ao último monólito tocado (ou ao início, se nenhum).
func _game_over() -> void:
	if Game.cp_zone >= 0:
		pending_spawn = Game.cp_pos
		_start_zone(Game.cp_zone)
		show_message("A Névoa te alcançou. Você volta ao último monólito.")
	else:
		_start_zone(0)
		show_message("A Névoa te alcançou. Você volta ao início.")


func on_door_reached() -> void:
	if mode != "play" or not world.unlocked.has("porta"):
		return
	_encerrar_fuga()
	if zone < Zones.DATA.size() - 1:
		_start_zone(zone + 1)
	else:
		_show_ending()


func show_message(texto: String) -> void:
	hud.show_message(texto, 3.0)


# ---------- diálogo ----------

func _say(linhas: Array, depois: Callable = Callable()) -> void:
	Game.dialog_open = true
	player.can_move = false
	dialog_after = depois
	hud.show_dialog(linhas)


func _end_dialog() -> void:
	Game.dialog_open = false
	player.can_move = true
	var f := dialog_after
	dialog_after = Callable()
	if f.is_valid():
		f.call()
