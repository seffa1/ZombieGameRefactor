extends Node2D

"""
Each gun should have a reticle as a child. This is essentially acting as a custom
mouse cursor which has gun sway and a halo-reach style accuracy indicator.
Export vars of the reticle should be adjusted on a per-gun basis. An apply recoil
function should be applied when the gun shoots.
"""

# Node references
@onready var reticle_top: Polygon2D = $ReticleTop
@onready var reticle_right: Polygon2D = $ReticleRight
@onready var reticle_bottom: Polygon2D = $ReticleBottom
@onready var reticle_left: Polygon2D = $ReticleLeft
@onready var recoil_reduction_timer: Timer = $RecoilReductionTimer
@onready var sway_timer: Timer = $SwayTimer

# Weapon sway
@export var weapon_sway: bool = true  # feature toggle
@export var weapon_sway_max: int = 100  # max radius of weapon sway
@export var weapon_sway_min: int = 50  # min radius of weapon sway
@export var sway_interval: float = .1  # speed in which the sway position is updated
@export var sway_speed: float = .2 # speed weapon moves to new position

# Variables - Weapon Sway
var _noise = FastNoiseLite.new() # used for weapon sway
var i = 0 # used for weapon sway
var weapon_sway_y_direction: int = 1  # flips between pos and negative based on sway_interval

 # feature toggle
@export var weapon_recoil: bool = true 

# Config values
@export var recoil_reduction_interval: float = .005 # how many seconds to lose a recoil amount - should be constant

# Recoil control
@export var recoil_per_shot: float = 30.0 # pixels the reticle moves per shot, set on a per-gun basis
@export var recoil_max: float = 100.0 # max pixels the reticle moves, adjusted by the state
@export var recoil_min: float = 0.0  # max pixels the reticle moves, adjusted by the state. All guns should set this to 0 except shotguns typically
@export var recoil_reduct_amount: int = 2 # the amount of recoil lost per interval - adjusted by the state


# Variables - recoil
var recoil_amount: float = 0:  # tracks the current recoil value which determines cross-hair state and bullet accuracy
	set(value):
		recoil_amount = clamp(value, 0, recoil_max)
		_set_reticle(recoil_amount)
	get:
		return recoil_amount

func _ready():
	Events.player_idle.connect(_player_idle)
	Events.player_moving.connect(_player_moving)
	Events.player_sprinting.connect(_player_sprinting)

# We use a state queue just for aiming down sight
# So if you ADS, then let go and you didnt change player states, you go back to the previous state
var state_stack = ["idle"]

func set_recoil_state(state: String):
	"""
	State machine for the reticle which updates its properties based on the player's movement states.
	In order of how accurate the reticle should be.
	"""
	
	assert( !(state_stack[0] == "aim_down_sight" and state == "aim_down_sight"), "Getting ADS signal while already ADSing" )
	
	# If the player is ADS and they sprint, cancel the ADS
	if state_stack[0] == "aim_down_sight" and state == "sprinting":
		# ["aim_down_sight", "idle"] -> player sprints -> ["sprinting"]
		state_stack = ["sprinting"]
		
	# If the player is ADS and they change from idle to moving, update the queue but keep ADS as the current state
	elif state_stack[0] == "aim_down_sight" and (state == "idle" or state == "moving"):
		# ["aim_down_sight", "idle"] -> player moves -> ["aim_down_sight", "moving"]
		# ["aim_down_sight", "moving"] -> player idles -> ["aim_down_sight", "idle"]
		state_stack.pop_back()
		state_stack.push_back(state)
	
	# Make sure sprinting prevents aiming down sight
	elif state == "aim_down_sight" and state_stack[0] == "sprinting":
		state_stack = ["sprinting"]
	elif state == "release_aim_down_sight" and state_stack[0] == "sprinting":
		state_stack = ["sprinting"]
	
	# aiming down site
	elif state == "aim_down_sight":
		state_stack.push_front(state)
		# ["aim_down_sight", "idle"]
	elif state == "release_aim_down_sight":
		state_stack.pop_front()
		print("HERE")
		# ["aim_down_sight", "idle"] -> relase ADS -> ["idle"]
	else:
		state_stack = [state]
		# ["idle"]
	
	# Set the current state as whatever is at the front of the queue
	print(state_stack)
	var current_state = state_stack[0]
	
	# Based on the state, set the parameters of the reticle
	match current_state:
		"aim_down_sight":
			pass
		"idle":
			pass
		"moving":
			pass
		"sprinting":
			pass

func _player_idle():
	set_recoil_state("idle")
func _player_moving():
	set_recoil_state("moving")
func _player_sprinting():
	set_recoil_state("sprinting")

func calc_recoil_rotation(gun_position: Vector2) -> float:
	"""
	Based on the current width of the reticle, chooses a random vector
	within it for the gun to use to shoot in that direction.
	"""
	var vector_to_mouse = get_global_mouse_position() - gun_position
	
	# vector pointing from mouse to edge of recoil indicator, perpendicular to player
	# 1.57 is 90 deg in radians
	var recoil_vector = vector_to_mouse.normalized().rotated(1.57) * recoil_amount 
	
	# Vector pointing from gun, to the outer edge of the recoil indicator
	var max_recoil_vector = vector_to_mouse + recoil_vector
	
	# Find the angle from the mouse position, to outside of recoil indicator
	var max_recoil_angle = vector_to_mouse.angle_to(max_recoil_vector)
	
	# Choose a random spot within this range on either direction
	return randf_range(-max_recoil_angle, max_recoil_angle)

func _set_reticle_direction(reticle: Polygon2D, offset: float):
	match reticle.name:
		"ReticleTop":
			reticle_top.position.y = -offset
		"ReticleBottom":
			reticle_bottom.position.y = offset
		"ReticleRight":
			reticle_right.position.x = offset
		"ReticleLeft":
			reticle_left.position.x = -offset

func _set_reticle(offset: float):
	for reticle in [reticle_right, reticle_left, reticle_top, reticle_bottom]:
		_set_reticle_direction(reticle, offset)

func apply_bullet_recoil():
	recoil_amount += recoil_per_shot

@onready var sway_vector = Vector2.RIGHT

func _process(_delta):
	if !Globals.mouse_on_screen():
		return

	# reduce your recoil over time
	if recoil_reduction_timer.is_stopped():
		recoil_reduction_timer.start(recoil_reduction_interval)
		recoil_amount -= recoil_reduct_amount

	# Aim down sight
	if Input.is_action_just_pressed("aim_down_sight"):
		set_recoil_state("aim_down_sight")
	if Input.is_action_just_released("aim_down_sight"):
		set_recoil_state("release_aim_down_sight")

#	# weapon sway
	if !weapon_sway:
		global_position = get_global_mouse_position()
	
	else:
		global_position = get_global_mouse_position() + sway_vector * 10
		if sway_timer.is_stopped():
			sway_timer.start(sway_interval)
			i += 1
			if i > 1000:
				i = 1000
			
			sway_vector = sway_vector.rotated(sin(i))
			

#
#	_noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
#	_noise.seed = randi()
#	_noise.fractal_octaves = 4
#	_noise.frequency = 1.0 / 20.0
#
#	# Get a new noise value
#	if sway_timer.is_stopped():
#		sway_timer.start(sway_interval)
#		weapon_sway_y_direction *= -1
#		var noise_value = abs(_noise.get_noise_1d(i) * randi_range(weapon_sway_min, weapon_sway_max))
#		i += 1
#		if i > 100:
#			i = 0
#
#		# only move the mouse if its in the viewport
#		if get_viewport().get_mouse_position().x > get_viewport().get_visible_rect().size.x or get_viewport().get_mouse_position().x < 0:
#			return
#		if get_viewport().get_mouse_position().y > get_viewport().get_visible_rect().size.y or get_viewport().get_mouse_position().y < 0:
#			return
#		var x_direction = randi_range(-1, 1)
#		var new_pos = Vector2(last_mouse_movement_input_position.x + noise_value * x_direction, last_mouse_movement_input_position.y + noise_value * weapon_sway_y_direction)
#		get_viewport().warp_mouse(new_pos)
			


