extends "res://Player/states/movement/motion.gd"

"""

"""

@export var WALK_SPEED_FOWARD: int = 300
@export var WALK_SPEED_BACKWARDS: int = 300
@export var MIN_SPRINT_STAMINA_COST: int = 10 # min amount of stamina you need in order to sprint

@onready var velocity_component = $"../../VelocityComponent"
@onready var stamina_component = $"../../StaminaComponent"
@onready var leg_animation_player = $"../../LegAnimation"

var is_moving_forward: bool  # Used to track which animation we should be playing (forward or backwards)

# Initialize the state. E.g. change the animation
func enter():
	Events.emit_signal("player_moving")
	is_moving_forward = true
	leg_animation_player.play("walkForward")
	
	# Reset speed since sprint state will increase it
	leg_animation_player.speed_scale = 1
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event: InputEvent):
	if event.is_action_pressed("sprint"):
		if stamina_component.stamina >= MIN_SPRINT_STAMINA_COST:
			emit_signal("finished", "sprint")
			return

func update(delta):
	# Rotate towards mouse
	update_look_direction()
	
	var input_direction = get_input_direction().normalized()
	if not input_direction:
		emit_signal("finished", "idle")
		return
		
	# Set leg animation direction
	_get_walk_direction(input_direction)

	# adjust speed multiplier if aiming down site
	var ADS_speed_multiplier = 1.0
	if Input.is_action_pressed("aim_down_sight"):
		ADS_speed_multiplier = .5

	# Update velocity and animation based on movement direction relative to player direction (forward or backwards)
	if _is_moving_forward(input_direction):
		# Set velocity for fowards
		velocity_component.max_velocity = WALK_SPEED_FOWARD * ADS_speed_multiplier
		# Update animation ONLY if we are just switching to foward from backwards
		if !is_moving_forward:
			is_moving_forward = true
			leg_animation_player.play("walkForward")
	else:
		# Set velocity for backwards
		velocity_component.max_velocity = WALK_SPEED_BACKWARDS * ADS_speed_multiplier
		if is_moving_forward:
			is_moving_forward = false
			leg_animation_player.play("walkBackwards")
	
	# update velocity
	velocity_component.accelerate_in_direction(input_direction, delta)
	
	# move the player
	owner.velocity = velocity_component.velocity
	owner.move_and_slide()


func _is_moving_forward(input_direction):
	"""
	Check if the player is moving in the same direction as they are facing.
	This will determine the speed they are moving for both the move and sprint state.
	"""
	var player_rotation = rad_to_deg(owner.rotation)
	var player_direction = rad_to_deg(input_direction.angle())
	
	# Case if the player if moving left because that is where the negative sign flips
	if abs(player_direction) > 100:
		if abs(abs(player_rotation) - abs(player_direction)) > 90:
			Events.emit_signal("player_direction_change", "Backwards")
			return false
		else:
			Events.emit_signal("player_direction_change", "Forwards")
			return true
	# Case if the player if moving right because that is where the negative sign flips
	else:
		if abs(player_rotation - player_direction) > 90:
			Events.emit_signal("player_direction_change", "Backwards")
			return false
		else:
			Events.emit_signal("player_direction_change", "Forwards")
			return true

func _get_walk_direction(input_direction):
	var player_rotation = rad_to_deg(owner.rotation)
	var player_direction = rad_to_deg(input_direction.angle())
	print("Rotation")
	print(player_rotation)
	print("Direction")
	print(player_direction)
	
	# Case if the player if moving left because that is where the negative sign flips
	if abs(player_direction) > 100:
		if abs(abs(player_rotation) - abs(player_direction)) > 90:
			print("Backwards moving left")
		else:
			print("Fowards moving left")
	# Case if the player if moving right, up, or down (because godot rounding makes up/down slightly more right)
	else:
		if abs(player_rotation - player_direction) > 225:
			if abs(player_rotation) > 134:
				print("right3")
			else:
				print("left3")
		elif abs(player_rotation - player_direction) > 135:
			print("Backwards")
		elif abs(player_rotation - player_direction) > 45:
			if (player_rotation > 90):
				if player_direction > 0:
					print("left1")
				else:
					print("right1")
			else:
				if abs(player_rotation) > 134:
					print("right2")
				else:
					print("left2")
		else:
			print("Fowards")


func _on_animation_finished(anim_name):
	return
