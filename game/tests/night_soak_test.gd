extends Node

## Recorre la noche entera saltando minutos y alternando pantallas, con
## apuestas y cobros aleatorios, para cazar errores en todos los estados.
func _ready() -> void:
	var main = load("res://scenes/night.tscn").instantiate()
	add_child(main)
	await get_tree().process_frame
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	for night in 2:
		Night.new_night(100 + night)
		main.go("bar")
		var screens := ["bar", "machine", "match_tv", "race_tv", "paper", "machine"]
		var i := 0
		while not Night.over:
			var s: String = screens[i % screens.size()]
			if s == "machine":
				main.go("machine", {"tab": ["football", "horses", "tickets"][i % 3]})
			else:
				main.go(s)
			await get_tree().process_frame
			await get_tree().process_frame
			if rng.randf() < 0.5:
				var r := Night.races.next_open(Night.minute())
				if not r.is_empty():
					Night.place_horse(int(r["index"]), rng.randi_range(0, 5), 5)
			if rng.randf() < 0.3:
				for m in Night.football.matches:
					if Night.football.can_bet(m):
						Night.place_football(m["id"], ["1", "X", "2"][rng.randi_range(0, 2)], 5)
			if rng.randf() < 0.2:
				for b in Night.open_bets():
					if Night.cashout_value(b) > 0:
						Night.cashout(b)
						break
			if main.current_name == "machine" and main.current.tab == "tickets":
				main.current.refresh()
			Night.advance(rng.randi_range(2, 9))
			i += 1
		await get_tree().create_timer(1.5).timeout
		print("night ", night, " money ", Night.money, " bets ", Night.bets.size(), " screen ", main.current_name)
	print("NIGHT_SOAK_OK")
	get_tree().quit()
