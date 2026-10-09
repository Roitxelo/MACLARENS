extends Node

func _ready() -> void:
	for s in [1, 2, 3]:
		Night.new_night(s)
		Night.toast.connect(_on_toast)
		var m: Dictionary = Night.football.matches[0]
		print("seed ", s, " ", m["home"], " vs ", m["away"], " odds ", m["odds"], " fact ", m["fact"] != null)
		var m2: Dictionary = Night.football.matches[1]
		print("   ", m2["home"], " vs ", m2["away"], " odds ", m2["odds"])
		var r0: Dictionary = Night.races.races[0]
		for h in r0["horses"]:
			print("   ", h["name"], " ", h["rating"], " @", h["odds"])
		print("   winner ", r0["horses"][Night.races.winner(r0)]["name"], " tip ", r0["tip_horse"])
		Night.money = 1000
		print("   shop ", Night.shop, " buy ", Night.buy_trinket(0), Night.buy_trinket(1), " rounds ", Night.buy_round("buho"), Night.buy_round("buho"), Night.buy_round("cortado"))
		Night.place_football("match_0", "1", 10)
		Night.place_horse(0, 0, 10)
		Night.place_horse(1, 2, 10, "place")
		Night.start()
		Night.advance(int(Night.races.races[0]["start"]) + 2)
		print("   whip ", Night.whip(0, 1.0), " left ", Night.whips_left(0))
		Night.advance(100 - Night.minute())
		print("   money after 100min ", Night.money, " agenda ", Night.agenda())
		Night.advance(500)
		print("   streak ", Night.streak_text(), " best ", Night.best_streak, " debt ", Night.debt)
		print("   final money ", Night.money, " over ", Night.over, " bets ", Night.bets.map(func(b): return [b["label"], b["status"], b["payout"]]))
		Night.toast.disconnect(_on_toast)
	print("NIGHT_SIM_OK")
	get_tree().quit()

var _n := 0
func _on_toast(t: String, k: String) -> void:
	_n += 1
	if _n < 40:
		print("      toast[", k, "] ", t)
