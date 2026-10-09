class_name BetManager
extends RefCounted

var active_bet: Dictionary = {}
var last_result: String = ""

func has_active_bet() -> bool:
	return not active_bet.is_empty()

func place_home_win(snapshot: MatchSnapshot, stake: int) -> bool:
	if has_active_bet() or not GameState.spend_money(stake):
		return false
	active_bet = {
		"match_id": snapshot.id,
		"team": snapshot.home,
		"stake": stake,
		"placed_odds": snapshot.home_odds,
	}
	last_result = ""
	return true

func cashout(current_odds: float) -> int:
	if not has_active_bet():
		return 0
	var value := int(round(float(active_bet["stake"]) * float(active_bet["placed_odds"]) / maxf(current_odds, 1.01) * 0.90))
	GameState.add_money(value)
	last_result = "Cobro anticipado: %d €" % value
	active_bet.clear()
	return value

func cashout_value(current_odds: float) -> int:
	if not has_active_bet():
		return 0
	return int(round(float(active_bet["stake"]) * float(active_bet["placed_odds"]) / maxf(current_odds, 1.01) * 0.90))

func resolve(snapshot: MatchSnapshot) -> int:
	if not has_active_bet() or active_bet["match_id"] != snapshot.id:
		return 0
	var payout := 0
	if snapshot.home_score > snapshot.away_score:
		payout = int(round(float(active_bet["stake"]) * float(active_bet["placed_odds"])))
		GameState.add_money(payout)
		last_result = "Apuesta ganada: %d €" % payout
	else:
		last_result = "Apuesta perdida: %s no ganó" % active_bet["team"]
	active_bet.clear()
	return payout

func ticket_text() -> String:
	if not has_active_bet():
		return last_result if not last_result.is_empty() else "Sin apuesta activa"
	return "%s gana · %d € @ %.2f" % [active_bet["team"], active_bet["stake"], active_bet["placed_odds"]]
