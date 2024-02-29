extends Node2D


"""
Contains all health-related logic. Should be kept as a general use class that any 
player or enemy could use.
"""

@onready var regen_wait_timer: Timer = $regenWaitTime

@export var max_health: float
@export var health_regeneration: bool = false  # feature toggle for health regeneration
@export var health_regeneration_wait_time: float = 2.0  # how many seconds of no-damage taken before health regenerates
@export var health_regeneration_per_second: float = 10.0  # how much health is regenerated per game tick
@export var invincible_mode: bool = false

signal health_at_zero

var starting_max_health: int  # set in ready, tracked in case max health is modified
var last_damage_source: String

var health: float:
	get:
		return health
	set(value):
		if invincible_mode:
			health = max_health
			return
		if value < health:
			regen_wait_timer.start(health_regeneration_wait_time)
		if value <= 0:
			health = 0
			emit_signal("health_at_zero")
		elif value > max_health:
			health = max_health
		else:
			health = value

func _ready():
	health = max_health
	starting_max_health = max_health
	regen_wait_timer.start(health_regeneration_wait_time)

func _process(delta):
	if !health_regeneration:
		return
	if regen_wait_timer.is_stopped():
		health += health_regeneration_per_second * delta

func fill_health():
	health = max_health

func set_damage_source(source_name: String):
	if health <= 0:
		return
	assert(Globals.DAMAGE_TYPES.find(source_name) != -1, 'Damage type not in global index!')
	last_damage_source = source_name

