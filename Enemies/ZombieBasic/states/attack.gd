extends "res://Libraries/state.gd"

# TODO - window attacks should be a separate state so we can have a different animation

# Initialize the state. E.g. change the animation
func enter():
	owner.animation_player.play("zombie_attack_basic")

# Clean up the state. Reinitialize values like a timer
func exit():
	owner.animation_player.stop()

func update(delta):
	# Check if dead
	if owner.health_component.health == 0:
		emit_signal("finished", "die")
		return
		
	# Check if player not in reach anymore
	if !owner.player_detector.has_overlapping_areas():
		emit_signal("finished", "seek_player")
		return

