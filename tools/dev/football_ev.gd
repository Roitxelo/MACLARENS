extends SceneTree

## Valor esperado de las apuestas 1X2 de fútbol a cuota de salida.
## godot --headless --path game -s res://../tools/dev/football_ev.gd -- [noches]

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var n := int(args[0]) if args.size() > 0 else 2000
	var ret := {}   # clave -> [apostado, cobrado]
	for s in n:
		var fm := FootballMarket.new()
		fm.setup(s, [60, 270])
		for m in fm.matches:
			var odds: Dictionary = m["odds"]
			var sim: MatchSimulator = m["sim"]
			while not sim.finished:
				sim.advance_interval()
			var res := "1" if sim.home_score > sim.away_score else ("2" if sim.away_score > sim.home_score else "X")
			var fav := "1" if odds["1"] < odds["2"] else "2"
			for pick in ["1", "X", "2"]:
				var role: String = "X" if pick == "X" else ("fav" if pick == fav else "under")
				for key in ["p%d_%s" % [m["index"], pick], "rol_%s" % role, "%s_%s" % [m["home_id"], pick]]:
					if not ret.has(key):
						ret[key] = [0.0, 0.0]
					ret[key][0] += 1.0
					if pick == res:
						ret[key][1] += float(odds[pick])
	var keys := ret.keys()
	keys.sort()
	for k in keys:
		if ret[k][0] >= 50:
			print("%-28s n=%5d  EV=%+.2f" % [k, int(ret[k][0]), ret[k][1] / ret[k][0] - 1.0])
	quit()
