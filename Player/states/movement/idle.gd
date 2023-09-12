extends "res://Player/states/movement/motion.gd"

"""
The motion parent script handles the stamina regenerations.
"""

@onready var velocity_component = $"../../VelocityComponent"
@onready var leg_animation_player = $"../../LegAnimation"

# Initialize the state. E.g. change the animation
func enter():
	# TODO - owner.get_node("AnimationPlayer").play("idle")
	Events.emit_signal("player_direction_change", "n/a")
	Events.emit_signal("player_idle")
	leg_animation_player.play("RESET")
	return

func update(delta):
	update_look_direction() # Rotate towards mouse

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
