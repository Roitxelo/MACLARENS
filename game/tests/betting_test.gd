extends Node

const BetManagerScript := preload("res://betting/bet_manager.gd")

func _ready() -> void:
	var start_money := GameState.money
	var manager = BetManagerScript.new()
	var snapshot := MatchSnapshot.new({
		"id": "test",
		"home": "McLarens FC",
		"away": "Atlético Resaca",
		"home_odds": 2.0,
	})
	assert(manager.place_home_win(snapshot, 10))
	assert(GameState.money == start_money - 10)
	assert(not manager.place_home_win(snapshot, 10))
	assert(manager.cashout(2.0) == 9)
	assert(GameState.money == start_money - 1)

	assert(manager.place_home_win(snapshot, 10))
	snapshot.home_score = 1
	snapshot.away_score = 0
	assert(manager.resolve(snapshot) == 20)
	assert(GameState.money == start_money + 9)
	print("BETTING_TEST_OK")
	get_tree().quit()
