extends Node2D


"""
Contains all health-related logic. Should be kept as a general use class that any 
player or enemy could use.
"""

@onready var regen_wait_timer: Timer = $regenWaitTime

@export var max_health: float
@export var health_regeneration: bool = false  # feature toggle for health regeneration
@export var health_regeneration_wait_time: float = 2.0  # how many seconds of no-damage taken before health regenerates
@export var health_regeneration_amount_per_tick: float = .1  # how much health is regenerated per game tick

var starting_max_health: int  # set in ready, tracked in case max health is modified

var health: float:
	get:
		return health
	set(value):
		if value < health:
			regen_wait_timer.start(health_regeneration_wait_time)
		if value <= 0:
			health = 0
		elif value > max_health:
			health = max_health
		else:
			health = value

func _ready():
	print(max_health)
	health = max_health
	starting_max_health = max_health
	regen_wait_timer.start(health_regeneration_wait_time)

func _process(delta):
	if !health_regeneration:
		return
	if regen_wait_timer.is_stopped():
		health += health_regeneration_amount_per_tick
	
