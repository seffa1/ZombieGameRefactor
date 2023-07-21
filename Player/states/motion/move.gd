extends "res://Player/states/motion/motion.gd"

var speed = 0.0
var velocity = Vector2()

# Initialize the state. E.g. change the animation
func enter():
	speed = 0.0
	velocity = Vector2()
	
	var input_direction = get_input_direction()
	update_look_direction()
	# TODO - owner.get_node("AnimationPlayer").play("walk")

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event):
	return

func update(delta):
	var input_direction = get_input_direction()
	if !input_direction:
		emit_signal("finished", "idle")

func _on_animation_finished(anim_name):
	return
