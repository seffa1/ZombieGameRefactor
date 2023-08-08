extends Node2D

"""
Each gun should have a reticle as a child. This is essentially acting as a custom
mouse cursor which has gun sway and a halo-reach style accuracy indicator.
Export vars of the reticle should be adjusted on a per-gun basis. An apply recoil
function should be applied when the gun shoots.
"""

@onready var reticle_top: Polygon2D = $ReticleTop
@onready var reticle_right: Polygon2D = $ReticleRight
@onready var reticle_bottom: Polygon2D = $ReticleBottom
@onready var reticle_left: Polygon2D = $ReticleLeft
@onready var recoil_reduction_timer: Timer = $RecoilReductionTimer
@onready var sway_timer: Timer = $SwayTimer

@export var weapon_recoil: bool = true  # feature toggle
@export var recoil_per_shot: float = 30.0 # pixels the reticle moves per shot
@export var recoil_max: float = 100.0
@export var recoil_reduction_interval: float = .005 # how many seconds to lose a recoil amount
@export var recoil_reduct_amount: int = 2 # the amount of recoil lost per interval

@export var weapon_sway: bool = false  # feature toggle
@export var weapon_sway_max: int = 100  # max radius of weapon sway
@export var weapon_sway_min: int = 50  # min radius of weapon sway
@export var sway_interval: float = .5  # speed in which the sway position is updated
@export var sway_speed: float = .2 # speed weapon moves to new position

# Variables - recoil
var recoil_amount: float = 0:  # tracks the current recoil value which determines cross-hair state and bullet accuracy
	set(value):
		recoil_amount = clamp(value, 0, recoil_max)
		_set_reticle(recoil_amount)
	get:
		return recoil_amount
		
# Variables - Weapon Sway
var _noise = FastNoiseLite.new() # used for weapon sway
var i = 0 # used for weapon sway
var weapon_sway_y_direction: int = 1  # flips between pos and negative based on sway_interval

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

func _process(delta):
	if Globals.mouse_on_screen():
		global_position = get_global_mouse_position()

	# reduce your recoil over time
	if recoil_reduction_timer.is_stopped():
		recoil_reduction_timer.start(recoil_reduction_interval)
		recoil_amount -= recoil_reduct_amount

#	_set_reticle(100)

#	# weapon sway
#	if !gun_sway:
#		return
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
			


