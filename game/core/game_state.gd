extends Node

signal resources_changed(money: int, minutes_left: int, luck: int)

var money: int = 100
var minutes_left: int = 180
var luck: int = 3
var debt_target: int = 500
var days_left: int = 5
var day_start_money: int = 100

func reset_run() -> void:
	money = 100
	minutes_left = 180
	luck = 3
	debt_target = 500
	days_left = 5
	day_start_money = money
	resources_changed.emit(money, minutes_left, luck)

func start_next_day() -> void:
	days_left = maxi(0, days_left - 1)
	minutes_left = 180
	luck = 3
	day_start_money = money
	resources_changed.emit(money, minutes_left, luck)

func spend_time(minutes: int) -> void:
	minutes_left = maxi(0, minutes_left - minutes)
	resources_changed.emit(money, minutes_left, luck)

func spend_money(amount: int) -> bool:
	if amount <= 0 or amount > money:
		return false
	money -= amount
	resources_changed.emit(money, minutes_left, luck)
	return true

func add_money(amount: int) -> void:
	money += maxi(0, amount)
	resources_changed.emit(money, minutes_left, luck)

func spend_luck(amount: int = 1) -> bool:
	if amount <= 0 or amount > luck:
		return false
	luck -= amount
	resources_changed.emit(money, minutes_left, luck)
	return true
