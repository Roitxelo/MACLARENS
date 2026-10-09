extends Node

func _ready() -> void:
	var scene = load("res://scenes/main_bar.tscn").instantiate()
	add_child(scene)
	await get_tree().process_frame
	await get_tree().process_frame
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://tests/output"))
	await _capture("bar_start")
	scene._open_contacts()
	await get_tree().create_timer(0.5).timeout
	await _capture("contacts")
	scene._on_back()
	await get_tree().create_timer(0.4).timeout
	scene._open_lucia()
	await get_tree().create_timer(0.5).timeout
	await _capture("lucia_conversation")
	scene._on_back()
	await get_tree().create_timer(0.4).timeout
	scene._open_paper()
	await get_tree().create_timer(0.5).timeout
	await _capture("newspaper_resting")
	scene._reveal_first_relation()
	await get_tree().create_timer(0.8).timeout
	await _capture("newspaper_related")
	scene._return_to_bar()
	await get_tree().create_timer(0.5).timeout
	scene._open_machine()
	await get_tree().create_timer(0.5).timeout
	await _capture("betting_machine")
	scene._confirm_bet()
	await get_tree().create_timer(1.7).timeout
	scene._open_machine()
	await get_tree().create_timer(0.5).timeout
	await _capture("live_market")
	scene.match_timer.stop()
	scene._show_end_day()
	await get_tree().create_timer(0.5).timeout
	await _capture("end_of_day")
	print("VISUAL_CAPTURE_OK")
	get_tree().quit()

func _capture(file_name: String) -> void:
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var error := image.save_png("res://tests/output/%s.png" % file_name)
	assert(error == OK)
