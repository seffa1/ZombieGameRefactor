extends "res://Libraries/state.gd"

"""
This state is used for testing only. The only way to access it is to set the starting
state of the state machine to this state.
"""

@onready var animation_player = $"../../AnimationPlayer"


# Initialize the state. E.g. change the animation
func enter():
	print("Playgin animation")
	print(animation_player.get_animation_list())
	print(animation_player.has_animation("stand_still_01"))
	animation_player.play("stand_still_01")
	print(animation_player.current_animation)

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func update(delta):
	print(animation_player.current_animation)
	return

func _on_animation_finished(anim_name):
	return

