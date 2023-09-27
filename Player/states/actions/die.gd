extends "res://Libraries/state.gd"

@onready var player_death_effect = preload("res://Player/PlayerDeathEffect.tscn")

# Initialize the state. E.g. change the animation
func enter():
	# Play player death visual effect
	var death_effect = player_death_effect.instantiate()
	death_effect.global_position = owner.global_position
	death_effect.global_rotation = owner.global_rotation
	
	ObjectRegistry.register_effect(death_effect)
	owner.queue_free()

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(_event):
	return

func update(_delta):
	return
