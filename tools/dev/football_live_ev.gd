extends SceneTree

## Valor esperado de apostar EN DIRECTO por minuto y situación del marcador.
## godot --headless --path game -s res://../tools/dev/football_live_ev.gd -- [noches]

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var n := int(args[0]) if args.size() > 0 else 2000
	var ret := {}
	for s in n:
		var fm := FootballMarket.new()
		fm.setup(s, [60, 270])
		for m in fm.matches:
			var sim: MatchSimulator = m["sim"]
			var snaps := []
			while not sim.finished:
				sim.advance_interval()
				m["minute"] = sim.minute
				if sim.minute in [30, 45, 60, 70, 78] and not sim.finished:
					var p := sim.pressure()
					snaps.append([sim.minute, sim.home_score - sim.away_score, fm.compute_odds(m), float(p["home_share"])])
			var res := "1" if sim.home_score > sim.away_score else ("2" if sim.away_score > sim.home_score else "X")
			for sn in snaps:
				var diff: int = sn[1]
				var state := "empate" if diff == 0 else ("gana1_%d" % mini(diff, 2) if diff > 0 else "gana2_%d" % mini(-diff, 2))
				var press := "pres1" if sn[3] > 0.6 else ("pres2" if sn[3] < 0.4 else "presN")
				for pick in ["1", "X", "2"]:
					for key in ["m%02d_%s_%s" % [sn[0], state, pick], "m%02d_%s_%s_%s" % [sn[0], press, state, pick]]:
						if not ret.has(key):
							ret[key] = [0.0, 0.0, 0.0]
						ret[key][0] += 1.0
						ret[key][2] += float(sn[2][pick])
						if pick == res:
							ret[key][1] += float(sn[2][pick])
	var keys := ret.keys()
	keys.sort()
	for k in keys:
		var ev: float = ret[k][1] / ret[k][0] - 1.0
		if ret[k][0] >= 150 and (ev > 0.0 or not k.contains("pres")):
			print("%-30s n=%5d cuota=%.2f EV=%+.2f" % [k, int(ret[k][0]), ret[k][2] / ret[k][0], ev])
	quit()
