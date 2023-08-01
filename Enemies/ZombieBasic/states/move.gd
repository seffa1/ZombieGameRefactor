extends "res://Libraries/state.gd"


@export var WALK_SPEED_FOWARD: int = 300


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
	
	# Check if theres a window to attack
	# TODO - do we need to check if we are outside or inside?
	if owner.window_detector.has_overlapping_areas():
		emit_signal("finished", "break_window")
		return

	# Move - velocity should be getting updated by the pathfinding component
	owner.velocity = owner.velocity_component.velocity.normalized() * WALK_SPEED_FOWARD
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func _on_animation_finished(anim_name):
	return

