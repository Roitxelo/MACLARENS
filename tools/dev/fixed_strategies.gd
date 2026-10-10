extends SceneTree

## C01 — ¿Alguna estrategia deportiva FIJA gana la campaña por sí sola?
## Cada bot repite lo mismo todas las noches, sin minijuegos ni compras.
## Uso: godot --headless --path game -s res://../tools/dev/fixed_strategies.gd -- [campañas]

const STRATS := ["nada", "favorito", "empate", "tapado", "mclarens", "lider_70", "caballo_fav", "caballo_tapado"]

var _night: Node

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var count := int(args[0]) if args.size() > 0 else 200
	print("Campañas por estrategia: %d (apuesta: 25 %% de la banca, máx. 50 €)" % count)
	for st in STRATS:
		var reached := [0, 0, 0, 0, 0, 0]
		var roi_sum := 0.0
		var staked_sum := 0.0
		for c in count:
			if _night != null:
				_night.free()
			_night = load("res://night/night_state.gd").new()
			var n = _night
			n.new_campaign(3000 + c)
			var cleared := 0
			for k in n.NIGHTS:
				var r: Array = _play(n, st)
				staked_sum += r[0]
				roi_sum += r[1]
				if not n.pay_tino():
					break
				cleared += 1
				if k < n.NIGHTS - 1:
					n.next_night()
			reached[cleared] += 1
		var line := ""
		var alive := count
		for k in 5:
			alive -= reached[k]
			line += "  N%d %3d %%" % [k + 1, int(round(100.0 * alive / count))]
		var ev := (roi_sum / staked_sum) if staked_sum > 0.0 else 0.0
		print("%-15s supera:%s   beneficio por € %+.2f" % [st, line, ev])
	quit()

## Juega una noche con la estrategia fija. Devuelve [apostado, beneficio neto de apuestas].
func _play(n, st: String) -> Array:
	n.running = true
	var staked := 0.0
	var start: int = n.money
	var done := {}
	while not n.over and n.minute() < n.NIGHT_LENGTH:
		var m: int = n.minute()
		var stake: int = clampi(n.money / 4, 5, n.MAX_TICKET)
		for mm in n.football.matches:
			var key: String = mm["id"]
			if done.has(key) or n.money < stake or not n.football.can_bet(mm):
				continue
			var pick := ""
			var o: Dictionary = mm["odds"]
			match st:
				"favorito":
					if mm["state"] == "pre": pick = "1" if o["1"] < o["2"] else "2"
				"empate":
					if mm["state"] == "pre": pick = "X"
				"tapado":
					if mm["state"] == "pre": pick = "2" if o["1"] < o["2"] else "1"
				"mclarens":
					if mm["state"] == "pre":
						if mm["home_id"] == "mclarens_fc": pick = "1"
						elif mm["away_id"] == "mclarens_fc": pick = "2"
				"lider_70":
					if mm["state"] == "live" and int(mm["minute"]) >= 70:
						var sim: MatchSimulator = mm["sim"]
						if sim.home_score > sim.away_score: pick = "1"
						elif sim.away_score > sim.home_score: pick = "2"
			if pick != "" and n.place_football(key, pick, stake):
				done[key] = true
				staked += stake
		if st.begins_with("caballo"):
			var r: Dictionary = n.races.next_open(m)
			if not r.is_empty() and int(r["start"]) - m <= 2 and not done.has("r%d" % r["index"]) and n.money >= stake:
				var pick_h: int = n.races.favourite(r)
				if st == "caballo_tapado":
					var best := 0
					for h in 6:
						if float(r["horses"][h]["odds"]) > float(r["horses"][best]["odds"]): best = h
					pick_h = best
				if n.place_horse(int(r["index"]), pick_h, stake):
					staked += stake
				done["r%d" % r["index"]] = true
		n.advance(1)
	return [staked, float(n.money - start)]
