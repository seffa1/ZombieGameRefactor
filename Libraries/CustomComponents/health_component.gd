extends Node2D


"""
Contains all health-related logic. Should be kept as a general use class that any 
player or enemy could use.
"""

@export var max_health: int = 50
@export var death_money_reward: int = 100

var health:
	get:
		return health
	set(value):
		if value <= 0:
			health = 0
		elif value > max_health:
			health = max_health
		else:
			health = value

func _ready():
	health = max_health
