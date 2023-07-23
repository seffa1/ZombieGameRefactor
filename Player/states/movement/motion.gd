extends "res://Libraries/state.gd"

"""
Movement functions shared between the idle and movement states. Any actions
which should interupt movement can also go here.
Stamina is managed here as well.
"""

@onready var stamina_regen_timer: Timer = owner.find_child("StaminaRegenTimer")
@onready var stamina_depletion_timer: Timer = owner.find_child("StaminaDepletionTimer")

@export var STAMINA_REGEN_TICK_RATE: float = 0.1  # seconds / tick of stamina regen
@export var STAMINA_REGEN_PER_TICK: int = 5  # stamina per regen tick
@export var STAMINA_USE_TICK_RATE: float = 0.1
@export var STAMINA_USE_PER_TICK: int = 1

func handle_input(event):
	# TODO - anything that should intrupt any motion states here, dashing for example 
	return

func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_direction

func update_look_direction():
	owner.look_at(owner.get_global_mouse_position())
	
func regenerate_stamina():
	"""
	Any state which in which stamina can be recovered in will call this function
	during its update.
	"""
	if stamina_regen_timer.is_stopped():
		stamina_regen_timer.start(STAMINA_REGEN_TICK_RATE)
		owner.stamina += STAMINA_REGEN_PER_TICK

func deplete_stamina():
	"""
	The sprint state calls this to deplete stamina.
	"""
	return
