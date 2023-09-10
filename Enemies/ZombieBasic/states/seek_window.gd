extends "res://Libraries/state.gd"

"""
Starting state for the zombie. A target window is set by the zombie spawner
in the zombie base node. Zombie seeks that window until hes within range, then
switched to break window state.
"""

@onready var animation_player = $"../../AnimationPlayer"
@onready var groan_timer: Timer = $"../../GroanTimer"
@onready var zombie_groans = $"../../ZombieGroans-Audio"

@export var groan_interval = 3  # min seconds between random groans

func enter():
	animation_player.play("zombie_walk_basic")
	groan_timer.start(groan_interval + randf_range(0, 15))

# Clean up the state. Reinitialize values like a timer
func exit():
	groan_timer.stop()
	return

func update(delta):
	# Check if dead
	if owner.health_component.health == 0:
		emit_signal("finished", "die")
		return
		
	# Check if we should do a random groan
	if groan_timer.is_stopped():
		zombie_groans.play_long()
		groan_timer.start(groan_interval + randf_range(0, 10))
	
	# Update pathfinding component target position to the window
	owner.pathfinding_component.update_target_position(owner.target_window.global_position)

	# Check if we have arrived at a window
	if owner.window_detector.has_overlapping_areas():
		# Check if the window has health
		var window_hurtbox = owner.window_detector.get_overlapping_areas()[0]
		if window_hurtbox.owner.is_broken():
			emit_signal("finished", "seek_inside")
		else:
			emit_signal("finished", "break_window")

	# Move - velocity should be getting updated by the pathfinding component
	# the pathfinding target position is set by the owner in the ready function
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

	return

func _on_animation_finished(anim_name):
	return
