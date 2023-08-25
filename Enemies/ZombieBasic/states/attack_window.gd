extends "res://Libraries/state.gd"

"""
If a zombie is outside and within reach of a window, do break window animation.
"""

# Initialize the state. E.g. change the animation
func enter():
	owner.animation_player.play("zombie_break_window_basic")


# Clean up the state. Reinitialize values like a timer
func exit():
	owner.animation_player.stop()

func update(delta):
	# movement
	owner.velocity_component.decelerate(delta)
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Check if dead
	if owner.health_component.health == 0:
		emit_signal("finished", "die")
		return
	
	# We should always have an overlapping window
	if owner.window_detector.has_overlapping_areas():
		# Check if the window's health is down to zero
		var window_hurtbox = owner.window_detector.get_overlapping_areas()[0]
		# Then go inside
		if window_hurtbox.owner.is_broken():
			emit_signal("finished", "seek_inside")
			return
	else:
		# If for some reason we lost the window overlap (cause we got knocked back for example)
		# Go back to seeking the window
		emit_signal("finished", "seek_window")
	
	# TODO - if player is detected, have a change to attack_player_through_window


