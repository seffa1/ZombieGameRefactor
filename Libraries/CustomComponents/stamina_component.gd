extends Node


"""
All the logic for manipulating stamina and regenerating it
is here.
"""


@export var STAMINA_USE_PER_TICK: float = 0.01  # stamina use per game tick
@export var starting_max_stamina: float = 100
@export var starting_regen_per_tick: float = 0.3  # stamina regen per game tick,

var max_stamina: float = 100.0  # updated by perk manager when getting stamina boost
var stamina_regen_per_tick: float  #  updated by perk manager when getting stamina boost
var is_stamina_depleting: bool = false  # stamina regenerates unless this is true, then it depletes

@onready var stamina: float = 0.0:
	set(value):
		var new_stamina
		if value > max_stamina:
			new_stamina = max_stamina
		elif value < 0:
			new_stamina = 0
		else:
			new_stamina = value
		stamina = new_stamina
		Events.emit_signal("player_stamina_change", new_stamina)

func _ready():
	max_stamina = starting_max_stamina
	stamina = starting_max_stamina
	stamina_regen_per_tick = starting_regen_per_tick

func _process(delta):
	if is_stamina_depleting:
		stamina -= STAMINA_USE_PER_TICK
	else:
		stamina += stamina_regen_per_tick
