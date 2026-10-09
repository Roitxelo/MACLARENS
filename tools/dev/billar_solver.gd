extends SceneTree
## Busca soluciones para cada mesa del billar barriendo ángulo y potencia.
## Uso: godot --headless --path game -s ../tools/dev/billar_solver.gd [paso_grados]
func _init():
	var step_deg := 1.0
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		step_deg = float(args[0])
	var powers := [0.35, 0.5, 0.65, 0.8, 1.0]
	for lv in [1, 2, 3]:
		for idx in 3:
			var t0 := Time.get_ticks_msec()
			var lay := BilliardLayouts.build(lv, idx)
			var ok := 0
			var total := 0
			var best := []
			var good_angles := 0
			var a := 0.0
			while a < 360.0:
				var any := false
				for pw in powers:
					var sim := BilliardSim.new()
					sim.setup(lay["balls"])
					sim.shoot(deg_to_rad(a), pw)
					sim.run_to_rest()
					total += 1
					if sim.evaluate(lay["rules"])["ok"]:
						ok += 1
						any = true
						if best.size() < 4:
							best.append("%.2f°/%.2f" % [a, pw])
				if any:
					good_angles += 1
				a += step_deg
			print("Nv%d #%d %-22s ventana %.2f°  (%d/%d tiros)  ej: %s  [%d ms]" % [lv, idx + 1, lay["name"], good_angles * step_deg, ok, total, ", ".join(best), Time.get_ticks_msec() - t0])
	quit()
