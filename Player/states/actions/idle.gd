extends "res://Libraries/state.gd"


# Initialize the state. E.g. change the animation
func enter():
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event):
	return

func update(delta):
	if Input.is_action_just_pressed("shoot"):
		emit_signal("finished", "shoot")

