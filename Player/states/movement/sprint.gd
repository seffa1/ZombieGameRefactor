extends "res://Player/states/movement/motion.gd"

@export var RUN_SPEED: int = 395

# Initialize the state. E.g. change the animation
func enter():
	# TODO - play animation
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event: InputEvent):
	# if we arent holding sprint down, stop
	if event.is_action_released("sprint"):
		emit_signal("finished", "previous")

func update(delta):
	# Rotate towards mouse
	update_look_direction()
	
	# Make sure we are still holding the sprint key
	if !Input.is_action_pressed("sprint"):
		emit_signal("finished", "previous")
	
	# Make sure we have the stamina
	if owner.stamina < 1:
		emit_signal("finished", "previous")
	
	# TODO - limit player from spinning around, prevent actions
	deplete_stamina()
	
	# move the player
	var input_direction = get_input_direction()
	if not input_direction:
		emit_signal("finished", "previous")
	owner.velocity = input_direction.normalized() * RUN_SPEED
	owner.move_and_slide()

func _on_animation_finished(anim_name):
	return


