extends "res://Player/states/motion/motion.gd"

# Initialize the state. E.g. change the animation
func enter():
	# TODO - owner.get_node("AnimationPlayer").play("idle")
	return

func update(delta):
	# Rotate towards mouse
	update_look_direction()
	
	# Check if movement input, if so, change to move state
	var input_direction = get_input_direction()
	if input_direction:
		emit_signal("finished", "move")

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event):
	return super(handle_input(event))
