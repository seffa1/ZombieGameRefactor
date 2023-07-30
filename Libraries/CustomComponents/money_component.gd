extends Node


"""
All the logic for tracking and manipulating a money counter.
Emits signals for updating UI.
"""

@export var STARTING_MONEY: int = 10000

var money: int = 0:
	set(value):
		var new_money
		if value < 0:
			new_money = 0
		else:
			new_money = value
		money = new_money
		Events.emit_signal("player_money_change", money)
	get:
		return money

func _ready():
	money = STARTING_MONEY

func add_money(amount: int):
	money += amount
