# Teste de fumaça: carrega dados, mapas e cenas e roda alguns quadros do jogo.
# Execução (CI): godot --headless --path . res://tests/smoke_test.tscn
# (roda como cena para que os autoloads, como Game, já existam ao compilar.)
extends Node

const Zones = preload("res://scripts/zones.gd")
const Mundo = preload("res://scripts/world.gd")
const Principal = preload("res://scripts/main.gd")

var falhas := 0


func check(cond: bool, msg: String) -> void:
	if cond:
		print("  ok    ", msg)
	else:
		print("  FALHA ", msg)
		falhas += 1


func _ready() -> void:
	_executar.call_deferred()


func _executar() -> void:
	print("Mnemos 2.0 — smoke test")
	check(Zones.DATA.size() == 7, "7 degraus carregados")
	for i in range(Zones.DATA.size()):
		var d: Dictionary = Zones.DATA[i]
		var linhas: Array = d["map"]
		var txt := ""
		var ok_larg := true
		for l in linhas:
			txt += str(l)
			ok_larg = ok_larg and str(l).length() == 40
		check(linhas.size() == 18 and ok_larg, "degrau %d: mapa 40x18" % (i + 1))
		check(txt.count("P") == 1 and txt.count("M") == 1 and txt.count("N") == 1,
			"degrau %d: tem P, M e N" % (i + 1))

	var mundo = Mundo.new()
	get_tree().root.add_child(mundo)
	mundo.load_map(Zones.DATA[0]["map"], "~")
	check(not mundo.walkable_char("~"), "abismo bloqueia sem o fio de seda")
	mundo.unlocked["seda"] = true
	check(mundo.walkable_char("~"), "abismo libera com a seda")

	check(Game.load_tex("res://assets/sprites/player/ant_player.png") != null, "sprite da formiga carrega")
	check(Game.load_tex("res://assets/sprites/tiles/tiles.png") != null, "atlas de tiles carrega")
	check(FileAccess.file_exists("res://assets/fonts/KiwiSoda.ttf"), "fonte KiwiSoda presente")

	var principal = Principal.new()
	get_tree().root.add_child(principal)
	for _i in range(30):
		principal._process(1.0 / 60.0)
	check(principal.mode == "title", "começa no título")

	Game.reset_new_game()
	principal._start_zone(0)
	check(principal.mode == "play", "entra no degrau 1")
	for _i in range(120):
		principal._process(1.0 / 60.0)
	check(principal.world.width == 40, "roda 120 quadros no degrau 1")

	Game.reset_new_game()
	principal._start_zone(6)
	check(principal.boss_node != null, "chefe final aparece no degrau 7")
	for _i in range(60):
		principal._process(1.0 / 60.0)

	# Monólito de save no degrau 1 e ponto de retorno que sobrevive ao save.
	var txt1 := ""
	for l in Zones.DATA[0]["map"]:
		txt1 += str(l)
	check(txt1.count("S") == 1, "degrau 1 tem um monólito de save")
	Game.reset_new_game()
	Game.set_checkpoint(2, Vector2(100, 50))
	Game.save_game()
	Game.cp_zone = -1
	Game.load_game()
	check(Game.cp_zone == 2 and Game.cp_pos == Vector2(100, 50), "checkpoint volta do save")

	# Cutscene inicial: começa no modo cutscene, depois do título.
	principal._start_cutscene()
	check(principal.mode == "cutscene", "novo jogo abre a cutscene")

	Game.reset_new_game()
	print("")
	if falhas == 0:
		print("RESULTADO: OK")
	else:
		print("RESULTADO: %d falha(s)" % falhas)
	get_tree().quit(1 if falhas > 0 else 0)
