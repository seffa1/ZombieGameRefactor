extends "res://Libraries/state.gd"

"""
Movement functions shared between the idle and movement states. Any actions
which should interupt movement can also go here.
Stamina is managed here as well.
"""

func handle_input(_event):
	# TODO - anything that should intrupt any motion states here, dashing for example 
	return

func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_direction

func update_look_direction():
	# TODO - replace this with a steer force. Sprinting state will have a low steer force and moving will have near-instant steer force
#	owner.look_at(owner.get_global_mouse_position())
	owner.update_rotation()


