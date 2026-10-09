extends Node

func _ready() -> void:
	var scene = load("res://scenes/main_bar.tscn").instantiate()
	add_child(scene)
	await get_tree().process_frame
	assert(scene.tv_state.text.contains("%.2f" % scene.snapshot_a.home_odds))
	assert(scene.tv_state_b.text.contains("%.2f" % scene.snapshot_b.home_odds))

	scene._open_paper()
	scene._reveal_first_relation()
	await get_tree().create_timer(0.8).timeout
	scene._return_to_bar()
	scene._open_machine()
	var market_b := scene.canvas.get_node("MarketB") as Button
	market_b.pressed.emit()
	assert(scene.selected_match_id == scene.snapshot_b.id)
	var odds_b := scene.canvas.get_node("OddsB") as Label
	assert(odds_b.text == "%.2f" % scene.snapshot_b.home_odds)
	var chosen_odds: float = scene.snapshot_b.home_odds
	scene._confirm_bet()
	assert(scene.betting.active_bet["match_id"] == scene.snapshot_b.id)
	assert(is_equal_approx(float(scene.betting.active_bet["placed_odds"]), chosen_odds))
	await get_tree().create_timer(1.7).timeout
	assert(scene.tv_state_b.text.contains("%.2f" % scene.snapshot_b.home_odds))
	var expected_cashout: int = scene.betting.cashout_value(scene.snapshot_b.home_odds)
	assert(expected_cashout > 0)
	print("MARKET_TRUTH_OK")
	get_tree().quit()
