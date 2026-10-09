class_name MatchSnapshot
extends RefCounted

var id: String
var home: String
var away: String
var home_score: int
var away_score: int
var minute: int
var home_odds: float
var last_event: String

func _init(data: Dictionary) -> void:
	id = str(data.get("id", ""))
	home = str(data.get("home", "Local"))
	away = str(data.get("away", "Visitante"))
	home_score = int(data.get("home_score", 0))
	away_score = int(data.get("away_score", 0))
	minute = int(data.get("minute", 0))
	home_odds = float(data.get("home_odds", 2.0))
	last_event = str(data.get("last_event", "Calentamiento"))

