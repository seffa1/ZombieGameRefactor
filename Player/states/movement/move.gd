extends "res://Player/states/movement/motion.gd"

"""

"""

@export var WALK_SPEED_FOWARD: int = 300
@export var WALK_SPEED_BACKWARDS: int = 300
@export var MIN_SPRINT_STAMINA_COST: int = 10 # min amount of stamina you need in order to sprint

@onready var velocity_component = $"../../VelocityComponent"
@onready var stamina_component = $"../../StaminaComponent"
@onready var leg_animation_player = $"../../LegAnimation"
@onready var leg_control = $"../../LegControl"

# Initialize the state. E.g. change the animation
func enter():
	Events.emit_signal("player_moving")
	
	# Reset speed since sprint state will increase it
	leg_animation_player.speed_scale = 1
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	leg_control.rotation = 0
	leg_control.global_rotation = owner.global_rotation
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

	# adjust speed multiplier if aiming down site
	var ADS_speed_multiplier = 1.0
	if Input.is_action_pressed("aim_down_sight"):
		ADS_speed_multiplier = .5
	
	# Update velocity and animation based on movement direction relative to player direction (forward or backwards)
	if _is_moving_forward(input_direction):
		# Set velocity for fowards
		velocity_component.max_velocity = WALK_SPEED_FOWARD * ADS_speed_multiplier
		leg_animation_player.play("walkForward")
		leg_control.global_rotation = input_direction.angle()
	else:
		# Set velocity for backwards
		velocity_component.max_velocity = WALK_SPEED_BACKWARDS * ADS_speed_multiplier
		leg_animation_player.play("walkBackwards")
		leg_control.global_rotation = 3.14 + input_direction.angle()

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

func _on_animation_finished(anim_name):
	return
