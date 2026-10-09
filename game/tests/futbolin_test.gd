extends Node

func _ready() -> void:
	Night.new_night(3)
	var main = load("res://scenes/night.tscn").instantiate()
	add_child(main)
	await get_tree().process_frame
	for sk in [0.3, 0.85]:
		for rep in 2:
			main.go("futbolin", {"rival": {"id": "cortado", "name": "X", "stake": 5, "skill": sk}, "autoplay": true})
			var f = main.current
			var t := 0.0
			while f.state != "over" and t < 60.0:
				await get_tree().create_timer(0.5).timeout
				t += 0.5
			print("skill ", sk, " score ", f.score, " t=", t)
	print("FUTBOLIN_TEST_DONE")
	get_tree().quit()
