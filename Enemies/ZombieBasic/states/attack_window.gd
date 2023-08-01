extends "res://Libraries/state.gd"

"""
If a zombie is outside and within reach of a window, do break window animation.
"""

# Initialize the state. E.g. change the animation
func enter():
	print("Entered break window state.")
	owner.animation_player.play("break_window")

# Clean up the state. Reinitialize values like a timer
func exit():
	owner.animation_player.stop()

func update(delta):
	# If theres no window detected, go back to moving
	if !owner.window_detector.has_overlapping_areas():
		emit_signal("finished", "move")
		return
	
	# TODO - if player is detected, have a change to attack_player_through_window

func _on_animation_finished(anim_name):
	return

