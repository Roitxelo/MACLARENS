extends Node

func _ready() -> void:
	var scene = load("res://scenes/main_bar.tscn").instantiate()
	add_child(scene)
	await get_tree().process_frame
	assert(scene.step == scene.Step.BAR_START)
	scene._open_paper()
	assert(scene.step == scene.Step.PAPER_OPEN)
	scene._use_luck()
	assert(GameState.luck == 2)
	assert(GameState.minutes_left == 179)
	scene._reveal_first_relation()
	await get_tree().create_timer(0.8).timeout
	assert(scene.step == scene.Step.CLUE_FOUND)
	assert(GameState.minutes_left == 177)
	scene._return_to_bar()
	assert(scene.step == scene.Step.BAR_INFORMED)
	scene._open_machine()
	assert(scene.step == scene.Step.MACHINE_OPEN)
	scene._confirm_bet()
	assert(scene.step == scene.Step.MATCH_LIVE)
	assert(GameState.money == 90)
	await get_tree().create_timer(1.7).timeout
	assert(scene.step == scene.Step.REVEAL)
	assert(GameState.minutes_left <= 176)
	assert(scene.betting.has_active_bet())
	var money_before_cashout := GameState.money
	scene._cashout()
	assert(not scene.betting.has_active_bet())
	assert(GameState.money > money_before_cashout)
	print("INTERACTION_FLOW_OK")
	get_tree().quit()
