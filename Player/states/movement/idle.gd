extends "res://Player/states/movement/motion.gd"

"""
The motion parent script handles the stamina regenerations.
"""

@onready var velocity_component = $"../../VelocityComponent"

# Initialize the state. E.g. change the animation
func enter():
	# TODO - owner.get_node("AnimationPlayer").play("idle")
	Events.emit_signal("player_direction_change", "n/a")
	return

func update(delta):
	update_look_direction() # Rotate towards mouse
	regenerate_stamina()
	
	# decelerate
	velocity_component.decelerate(delta)
	owner.velocity = velocity_component.velocity
	owner.move_and_slide()
	
	# Check if movement input, if so, change to move state
	var input_direction = get_input_direction()
	if input_direction:
		emit_signal("finished", "move")

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(_event):
	return
