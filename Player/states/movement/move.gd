extends "res://Player/states/movement/motion.gd"

"""
The motion parent script handles the stamina regenerations.
"""

@export var WALK_SPEED: int = 170
@export var RUN_SPEED: int = 395
@export var STAMINA_USE_RATE: float = .03  # seconds / point depleted (smaller the number, faster the depletion)
@export var MIN_SPRINT_STAMINA_COST: int = 10 # min amount of stamina you need in order to sprint

# Initialize the state. E.g. change the animation
func enter():
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event):
	if event.is_action_pressed("sprint"):
		if owner.stamina >= MIN_SPRINT_STAMINA_COST:
			emit_signal("finished", "sprint")
		

func update(delta):
	var input_direction = get_input_direction()
	if not input_direction:
		emit_signal("finished", "idle")
	
	regenerate_stamina()
	

func _on_animation_finished(anim_name):
	return
