extends "res://Libraries/state.gd"

@onready var zombie_groans = $"../../ZombieGroans-Audio"


# Initialize the state. E.g. change the animation
func enter():
	owner.animation_player.play("zombie_attack_basic")
	zombie_groans.play_attack()

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
		
	# Check if player not in reach anymore
	if !owner.player_detector.has_overlapping_areas():
		emit_signal("finished", "seek_player")
		return

