extends "res://Libraries/state.gd"

"""
Movement functions shared between the idle and movement states. Any actions
which should interupt movement can also go here.
"""

func handle_input(event):
	# TODO - anything that should intrupt any motion states here, dashing for example 
	return

func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_direction

func update_look_direction():
	owner.look_at(owner.get_global_mouse_position())
