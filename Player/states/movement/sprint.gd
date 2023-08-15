extends "res://Player/states/movement/motion.gd"

"""
The sprint action state cancels all other actions and plays an animation, while
the sprint movement state (this one) just handles player movement and leg animations/sounds.
"""

@export var SPRINT_SPEED_FORWARD: int = 500
@export var SPRINT_SPEED_BACKWARDS: int = 250

# Initialize the state. E.g. change the animation
func enter():
	# Emit signal for the action state to handle
	Events.emit_signal("player_sprinting")
	
	# Cancel player actions shoot state
	if owner.state_machine_action.states_stack[0] == owner.state_machine_action.states_map["shoot"]:
		owner.state_machine_action._change_state("idle")

	# TODO - play animation
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event: InputEvent):
	# if we arent holding sprint down, stop
	if event.is_action_released("sprint"):
		emit_signal("finished", "previous")
		return

func update(delta):
	# Rotate towards mouse
	update_look_direction()
	
	# Make sure we are still holding the sprint key
	if !Input.is_action_pressed("sprint"):
		emit_signal("finished", "previous")
		return
	
	# Make sure we have the stamina
	if owner.stamina < 1:
		emit_signal("finished", "previous")
		return
	
	# TODO - limit player from spinning around, prevent actions
	deplete_stamina()
	
	# move the player
	var input_direction = get_input_direction()
	if not input_direction:
		emit_signal("finished", "previous")
		return
	
	if _is_moving_forward(input_direction):
		owner.velocity = input_direction.normalized() * SPRINT_SPEED_FORWARD
	else:
		# you cant sprint backwards
		emit_signal("finished", "previous")
		return
	
	owner.move_and_slide()

func _on_animation_finished(anim_name):
	return

func _is_moving_forward(input_direction):
	"""
	Check if the player is moving in the same direction as they are facing.
	This will determine the speed they are moving for both the move and sprint state.
	"""
	var player_rotation = rad_to_deg(owner.rotation)
	var player_direction = rad_to_deg(input_direction.angle())
	
	# Special case if the player is moving left because that is where the
	# negative sign flips
	if abs(player_direction) > 100:
		if abs(abs(player_rotation) - abs(player_direction)) > 90:
			Events.emit_signal("player_direction_change", "Backwards")
			return false
		else:
			Events.emit_signal("player_direction_change", "Forwards")
			return true
	else:
		if abs(player_rotation - player_direction) > 90:
			Events.emit_signal("player_direction_change", "Backwards")
			return false
		else:
			Events.emit_signal("player_direction_change", "Forwards")
			return true

