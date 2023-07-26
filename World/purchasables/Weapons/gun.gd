
extends Node2D

"""
Base class for all guns. Its really just a bullet spawn with fx. All the gun animations
are a part of the player's animation tree, goverened by the StateMachineAction.

Has configurable settings for all bullet parameters to make all kinds of different shooting effects..
The MuzzlePosition is used as a reference position to spawn bullets/particle effects relative to the player.
Attachments like lasers and flashlights could also be a child of the muzzle.

Each child class should adjust the muzzle position based on assets used.
Optionally i may add another position node for the shell ejection spot but this
may end up as a part of the animation tree.
"""

# Exports
@export var WEAPON_NAME: String  # Must be in Globals.GUN_INDEX as a key
@export_enum("Base:1", "First Upgrade:2", "Second Upgrade:3") var weapon_level: int # 'pack-a-punch' level
@export_enum("single_fire", "automatic", "burst") var fire_type: String  # affects how the shoot state is exited
@export var bullet: PackedScene
@export var bullets_per_fire: int = 1
@export var bullet_spread: float = 0.0  # if bullets_per_fire > 1, this is the angle between the bullets
@export var bullet_speed: int = 1500
@export var bullet_damage: int = 10
@export var fire_rate: float = 0.2  # only applies if fire_type is automatic. Seconds per bullet fire
@export var clip_size: int = 25
@export var max_bullet_reserve: int = 500  # total bullets the gun can hold, other than the current clip
@export var reload_speed: float = 2.0  # reload animation should be dynamic for 'speed-cola' effects

# Variables
var bullets_in_clip: int
var bullet_reserve: int

# Nodes
@onready var fire_timer: Timer = $FireRateTimer
@onready var muzzle_position: Marker2D = $MuzzlePosition
# TODO - all guns need an audio node for shooting, reloading, etc.

func _ready():
	assert(fire_type != "", "Gun doesnt have a fire type selected.")
	assert(WEAPON_NAME != "", "Gun doesnt have a name set.: " + WEAPON_NAME)
	assert(bullet, "Bullet not assigned for gun.")
	
	bullets_in_clip = clip_size
	bullet_reserve = max_bullet_reserve

func shoot() -> void:
	"""
	Generic function used by all children. Should not need to be re-defined.
	The player shoot state will check 'can_shoot' before it calls this function since
	the state will dictate the animations.
	"""
	
	# we can ignore spread
	if bullets_per_fire == 1:
		var bullet_direction = Vector2(1,0).rotated(global_rotation)
		var spawn_position = muzzle_position.global_position
		
		var bullet_instance = bullet.instantiate()
		ObjectRegistry.register_projectile(bullet_instance)
		bullet_instance.init(bullet_damage, owner)
		bullet_instance.start(spawn_position, bullet_direction, bullet_speed)
		
		fire_timer.start(fire_rate)
		bullets_in_clip -= 1
		
		Events.emit_signal("player_equipped_clip_count_change", bullets_in_clip)
		Events.emit_signal("player_equipped_reserve_count_change", bullet_reserve)

	# we cannot ignore spread ( like a shot gun )
	else:
		if bullet_spread == 0:
			print("Spread shouldnt be zero for a gun firing multiple shots.")
		
		var bullet_rotation = global_rotation + (bullet_spread / 2)
		var spawn_position = muzzle_position.global_position
		var rotation_direction = 1
		
		# Although we are shooting multiple bullets in one shot, we treat this as one bullet in the clip
		# like a shotgun buck shot
		for i in bullets_per_fire:
			var bullet_direction = Vector2(1,0).rotated(bullet_rotation)
			
			var bullet_instance = bullet.instantiate()
			ObjectRegistry.register_projectile(bullet_instance)
			bullet_instance.init(bullet_damage, owner)
			bullet_instance.start(spawn_position, bullet_direction, bullet_speed)
			
			rotation_direction *= -1
			bullet_rotation += bullet_spread * (i+1) * rotation_direction
			
			bullets_in_clip -= 1
			Events.emit_signal("player_equipped_clip_count_change", bullets_in_clip)
			Events.emit_signal("player_equipped_reserve_count_change", bullet_reserve)


func set_gun_level(weapon_level: int) -> void:
	"""
	Must be defined by children classes. Describes how weapon parameters are affected by upgrading.
	"""
	return

func can_shoot() -> bool:
	"""
	Called by the player's shoot state to check if it should shoot.
	"""
	# TODO - the shoot state should call these checks separetly since the fire_timer
	# shouldnt be tied to the animation
	# ill re-do the animation system later
	if !fire_timer.is_stopped():
		print("FIRE ON COOL DOWN")
		return false
	if bullets_in_clip == 0:
		print("GUN OUT OF BULLETS")
		# TODO - play empty gun sound effect
		return false
	return true
