extends Node

## Recorre todas las pantallas de la noche y guarda capturas en tests/output.
var main: Control

func _ready() -> void:
	main = load("res://scenes/night.tscn").instantiate()
	add_child(main)
	await _wait(0.4)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://tests/output"))
	Night.new_night(7)
	main.go("title")
	await _shot("n01_title")
	main.go("bar")
	Night.speed = 4
	await _wait(1.0)
	await _shot("n02_bar_start")
	main.go("salon")
	await _wait(0.5)
	await _shot("n02b_salon")
	Night.money = 400
	main.go("shop")
	await _wait(0.4)
	await _shot("n03_lucia_shop")
	Night.buy_round("buho")
	Night.buy_round("buho")
	Night.buy_round("cortado")
	Night.buy_trinket(0)
	Night.buy_trinket(1)
	main.go("machine", {"tab": "football"})
	await _wait(0.3)
	main.current._select_pick("match_0", "1")
	await _shot("n04_machine_football")
	main.current._place_bet()
	main.current._set_tab("horses")
	main.current.sel_horse = 2
	main.current.refresh()
	await _shot("n05_machine_horses")
	main.current._place_bet()
	Night.advance(int(Night.races.races[0]["start"]) + 2 - Night.minute())
	main.go("race_tv")
	await _wait(0.3)
	main.current._whip()
	await _shot("n06_race_running")
	Night.advance(80 - Night.minute())
	main.go("match_tv")
	await _wait(0.6)
	await _shot("n07_match_live")
	main.current._open_penalty()
	await _wait(0.5)
	await _shot("n07b_penalty")
	await _wait(3.0)
	main.go("machine", {"tab": "tickets"})
	await _wait(0.3)
	await _shot("n08_tickets")
	main.go("bar")
	await _wait(0.5)
	await _shot("n09_bar_live")
	main.go("paper")
	await _wait(0.3)
	await _shot("n10_paper")
	main.go("notebook")
	await _wait(0.3)
	await _shot("n11_libreta")
	main.go("billar_lobby")
	await _wait(0.3)
	await _shot("n13_billar_lobby")
	Night.trinkets.erase("tiza")
	main.go("billar", {"rival": {"id": "tino", "name": "Tino", "stake": 20, "level": 2}})
	await _wait(0.4)
	await _shot("n14a_billar_base")
	Night.trinkets.append("tiza")
	main.go("billar", {"rival": {"id": "tino", "name": "Tino", "stake": 20, "level": 2}})
	await _wait(0.4)
	await _shot("n14_billar")
	var g = main.current
	g.autoplay = true
	var t := 0.0
	while g.state != "over" and t < 60.0:
		await _wait(0.25)
		t += 0.25
	print("BILLAR aciertos ", g.made, " fallos ", g.missed, " tino lv ", Night.level("tino"))
	await _shot("n15_billar_end")
	Night.buy_round("chencho")
	Night.buy_round("chencho")
	main.go("cards")
	await _wait(0.3)
	main.current._deal()
	main.current._hunch()
	await _wait(0.4)
	await _shot("n16_cards")
	main.current._guess(1)
	main.current._cash()
	print("streak ", Night.streak_text())
	Night.speed = 1
	Night.advance(Night.NIGHT_LENGTH)
	await _wait(1.8)
	await _shot("n17_end")
	Night.stats["nights_paid"] = 3
	Night.stats["paid_total"] = 550
	Night.stats["best"] = {"text": "Acierto: C7 · Calimocho", "amount": 245, "night": 3}
	main.go("stats")
	await _wait(1.5)
	await _shot("n18_stats")
	print("money ", Night.money, " bets ", Night.bets.size(), " screen ", main.current_name, " debt ", Night.debt)
	print("NIGHT_CAPTURE_OK")
	get_tree().quit()

func _wait(s: float) -> void:
	await get_tree().create_timer(s).timeout

func _shot(n: String) -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	img.save_png("res://tests/output/%s.png" % n)
