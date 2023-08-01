extends "res://Libraries/state.gd"

# TODO - window attacks should be a separate state so we can have a different animation

# Initialize the state. E.g. change the animation
func enter():
	owner.animation_player.play("attack_player")

# Clean up the state. Reinitialize values like a timer
func exit():
	owner.animation_player.stop()

func update(delta):
	# Check if player not in reach anymore
	if !owner.player_detector.has_overlapping_areas():
		emit_signal("finished", "move")

func _on_animation_finished(anim_name):
	return
