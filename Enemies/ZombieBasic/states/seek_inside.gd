extends "res://Libraries/state.gd"

"""
This state finds the closest inside-builder-trigger, sets the pathfinder to go towards that trigger.
Then it constantly checks if we have hit that trigger, if so, switched to targeting the player.
This is to help the zombie cross the threshold between the outside and inside.
"""

@onready var animation_player = $"../../AnimationPlayer"

var target_inside_trigger = null

func enter():
	animation_player.play("zombie_walk_basic")
	
	# Find the closest inside trigger to target
	var smallest_distance = INF
	for trigger in get_tree().get_nodes_in_group("inside_trigger"):
		var distance = (owner.global_position - trigger.global_position).length()
		if distance < smallest_distance:
			smallest_distance = distance
			target_inside_trigger = trigger
	assert(target_inside_trigger != null, "There are no windows for spawner to target.")

	owner.pathfinding_component.update_target_position(target_inside_trigger.global_position)

# Clean up the state. Reinitialize values like a timer
func exit():
	var target_inside_trigger = null
	return

func update(delta):

	# Check if weve hit a trigger
	if owner.trigger_detector.has_overlapping_areas():
		emit_signal("finished", "attack_player")
		return

	# Move - velocity should be getting updated by the pathfinding component
	# the pathfinding target position is set by the owner in the ready function
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func _on_animation_finished(anim_name):
	return
