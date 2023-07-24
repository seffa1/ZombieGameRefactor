
extends Node2D

"""
Base class for all guns. Has configurable settings for all gun parameters.
The MuzzlePosition is used as a reference position to spawn bullets/particle effects.
Attachments like lasers and flashlights could also be a child of the muzzle.

Each child class should adjust the muzzle position based on assets used.
Optionally i may add another position node for the shell ejection spot.
"""

# Exports
@export var GUN_NAME: String
@export_enum("Base:1", "First Upgrade:2", "Second Upgrade:3") var weapon_level: int # 'pack-a-punch' level
@export_enum("single_fire", "automatic", "burst") var fire_type: String
@export var bullet: PackedScene
@export var bullets_per_fire: int = 1
@export var bullet_spread: float = 0.0  # if bullets_per_fire > 1, this is the angle between the bullets
@export var fire_rate: float = 0.2  # only applies if fire_type is automatic. Seconds per bullet fire
@export var clip_size: int = 25
@export var total_bullet_count: int = 500  # total bullets the gun can hold
@export var reload_speed: float = 2.0  # reload animation should be dynamic for 'speed-cola' effects

# Nodes
@onready var fire_timer: Timer = $FireRateTimer
@onready var muzzle_position: Marker2D = $MuzzlePosition
# TODO - all guns need an audio node for shooting, reloading, etc.

# Variables
var bullets_in_clip

func _ready():
	assert(fire_type != "", "Gun doesnt have a fire type selected.")
	assert(GUN_NAME != "", "Gun doesnt have a name set.")
	assert(bullet, "Bullet not assigned for gun.")
	
	bullets_in_clip = clip_size

func shoot() -> void:
	"""
	Generic function used by all children. Should not need to be re-defined.
	"""
	
	if !_can_shoot():
		return
	
	if bullets_per_fire == 1:
		var direction = Vector2(1,0).rotated(global_rotation)
	
	else:
		for i in bullets_per_fire:
			# TODO - use bullet spread to alter bullet direction in bullet init function
			print("Shooting " + str(i) + " bullet")


func set_gun_level(weapon_level: int) -> void:
	"""
	Must be defined by children classes. Describes how weapon parameters are affected by upgrading.
	"""
	return

func _can_shoot() -> bool:
	if !fire_timer.is_stopped():
		return false
	if bullets_in_clip == 0:
		# TODO - play empty gun sound effect
		return false
	return true
