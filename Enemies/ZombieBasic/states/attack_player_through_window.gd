extends "res://Libraries/state.gd"

"""
If the zombie is outside attacking a window and a player comes within range, the
zombie should reach through the window to hit the player (like in cod).
"""

# Initialize the state. E.g. change the animation
func enter():
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func update(delta):
	# Check if dead
	if owner.health_component.health == 0:
		emit_signal("finished", "die")
		return
	# TODO 
	return

func _on_animation_finished(anim_name):
	return

