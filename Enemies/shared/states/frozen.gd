extends "res://Libraries/state.gd"

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

# Initialize the state. E.g. change the animation
func enter():
	animation_player.pause()

# Clean up the state. Reinitialize values like a timer
func exit():
	animation_player.play()
