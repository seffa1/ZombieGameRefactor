extends "res://Player/states/movement/motion.gd"

"""
The motion parent script handles the stamina regenerations.
"""

@export var WALK_SPEED_FOWARD: int = 300
@export var WALK_SPEED_BACKWARDS: int = 300
@export var STAMINA_USE_RATE: float = .03  # seconds / point depleted (smaller the number, faster the depletion)
@export var MIN_SPRINT_STAMINA_COST: int = 10 # min amount of stamina you need in order to sprint

# Initialize the state. E.g. change the animation
func enter():
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event: InputEvent):
	if event.is_action_pressed("sprint"):
		if owner.stamina >= MIN_SPRINT_STAMINA_COST:
			emit_signal("finished", "sprint")
			return

func update(delta):
	# Rotate towards mouse
	update_look_direction()
	
	var input_direction = get_input_direction()
	if not input_direction:
		emit_signal("finished", "idle")
		return
	
	regenerate_stamina()
	
	# move the player
	
	if _is_moving_forward(input_direction):
		owner.velocity = input_direction.normalized() * WALK_SPEED_FOWARD
	else:
		owner.velocity = input_direction.normalized() * WALK_SPEED_BACKWARDS
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
	
	if abs(player_rotation - player_direction) > 110:
		Events.emit_signal("player_direction_change", "Backwards")
		return false
	else:
		Events.emit_signal("player_direction_change", "Forwards")
		return true
