extends Node

## Billar: (1) cada mesa tiene una solución guardada que funciona en la física
## actual; (2) una serie en autoplay con esas soluciones gana; (3) con tiros
## desviados pierde. Usa la pantalla real del minijuego.
func _ready() -> void:
	var ok := true
	for lv in [1, 2, 3]:
		for i in 3:
			var lay := BilliardLayouts.build(lv, i)
			var sim := BilliardSim.new()
			sim.setup(lay["balls"])
			sim.shoot(deg_to_rad(float(lay["solution"][0])), float(lay["solution"][1]))
			sim.run_to_rest()
			var r := sim.evaluate(lay["rules"])
			print("Nv%d #%d %s -> %s" % [lv, i + 1, lay["name"], r["reason"]])
			ok = ok and bool(r["ok"])
	Night.new_night(5)
	var main = load("res://scenes/night.tscn").instantiate()
	add_child(main)
	await get_tree().process_frame
	for noise in [0.0, 25.0]:
		var money_before: int = Night.money
		main.go("billar", {"rival": {"id": "tino", "name": "Tino", "stake": 20, "level": 1}, "autoplay": true, "aim_noise": noise})
		var g = main.current
		var t := 0.0
		while g.state != "over" and t < 60.0:
			await get_tree().create_timer(0.25).timeout
			t += 0.25
		print("ruido %.0f°: aciertos %d fallos %d dinero %d -> %d" % [noise, g.made, g.missed, money_before, Night.money])
		if noise == 0.0:
			ok = ok and g.made >= 2 and Night.money == money_before + 20
		else:
			ok = ok and g.made < 2 and Night.money < money_before
	# (4) La guía se calcula rápido en todas las mesas y ángulos (review 04: iba a saltos).
	var worst := 0.0
	var total := 0.0
	var calls := 0
	for lv in [1, 2, 3]:
		for i in 3:
			main.go("billar", {"rival": {"id": "tino", "name": "Tino", "stake": 20, "level": lv}})
			await get_tree().process_frame
			var b = main.current
			b.shot_index = i
			b._load_shot()
			for k in 72:
				for pw in [0.3, 1.0]:
					var t0 := Time.get_ticks_usec()
					b.guide_paths(deg_to_rad(k * 5.0), pw)
					var ms := float(Time.get_ticks_usec() - t0) / 1000.0
					worst = maxf(worst, ms)
					total += ms
					calls += 1
	print("guía: media %.2f ms, peor %.2f ms (%d cálculos)" % [total / calls, worst, calls])
	# Presupuesto: un fotograma a 60 fps (16,7 ms). En el PC de Roi (RX 580)
	# la media es ~1,5 ms y el peor caso ~10 ms (C09).
	ok = ok and total / calls < 3.0 and worst < 16.0
	print("BILLAR_TEST_OK" if ok else "BILLAR_TEST_FAIL")
	get_tree().quit()
