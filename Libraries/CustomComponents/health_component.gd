extends Node2D


"""
Contains all health-related logic. Should be kept as a general use class that any 
player or enemy could use.
"""

@export var max_health: int = 50

var starting_max_health: int  # set in ready, tracked in case max health is modified

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
	starting_max_health = max_health
