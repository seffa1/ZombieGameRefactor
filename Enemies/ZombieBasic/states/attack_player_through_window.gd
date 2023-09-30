extends "res://Libraries/state.gd"

"""
If the zombie is outside attacking a window and a player comes within range, the
zombie should reach through the window to hit the player (like in cod).
"""

# Initialize the state. E.g. change the animation
func enter():
	owner.velocity_component.velocity = 0.0
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func update(delta):
	# movement
	owner.velocity_component.decelerate(delta)
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()


func _on_animation_finished(anim_name):
	return

