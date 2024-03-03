
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
# Nodes
@onready var fire_timer: Timer = $FireRateTimer
@onready var muzzle_position: Marker2D = $MuzzlePosition
@onready var reticle = $Reticle
@onready var lower_weapon_ray_cast = $LowerWeaponRayCast
@onready var bullet_shell_spawner = $VFXSpawnerBulletShells
@onready var magazine_spawner = $VFXSpawnerMagazines
@onready var muzzle_flash_vfx = preload("res://VFX/muzzleFlash/MuzzleFlash.tscn");
@onready var audio = $GunAudio

# Exports
@export var WEAPON_NAME: String  # Must be in Globals.GUN_INDEX as a key
@export_enum("Base:1", "First Upgrade:2", "Second Upgrade:3") var weapon_level: int # 'pack-a-punch' level
@export_enum("single_fire", "automatic", "burst", "continuous") var fire_type: String  # affects how the shoot state is exited
@export_enum("projectile", "ray_cast") var bullet_type: String = "projectile"  # affects how the bullet is treated
@export var bullet_ray_cast: RayCast2D
@export var bullet: PackedScene
@export var bullets_per_fire: int = 1
@export var bullet_spread: float = 0.0  # if bullets_per_fire > 1, this is the angle between the bullets
@export var bullet_speed: int = 1500
@export var bullet_damage: float = 10.0
@export var bullet_knockback: float = 3.0
@export var fire_rate: float = 0.2  # only applies if fire_type is automatic. Seconds per bullet fire
@export var clip_size: int = 25
@export var max_bullet_reserve: int = 500  # total bullets the gun can hold, other than the current clip
@export var reload_speed: float = 2.0  # reload animation should be dynamic for 'speed-cola' effects
@export var has_penetrating_shots: bool = false
@export_enum("on_fire", "on_reload", "no_shell") var shell_ejection_type: String
@export_enum("on_reload", "no_magazine") var magazine_ejection_type: int

var starting_bullet_damage: float
var trigger_held: bool = false # used by continuously firing guns

# Variables
var bullets_in_clip: int:
	set(value):
		bullets_in_clip = value
		Events.emit_signal("player_equipped_clip_count_change", bullets_in_clip)
		
var bullet_reserve: int:
	set(value):
		bullet_reserve = value
		Events.emit_signal("player_equipped_reserve_count_change", bullet_reserve)

var starting_fire_rate: float  # Set in ready function, needed so we can reset fire rate if its changed by a perk (double tap)
var starting_recoil_per_shot: float  # Set in ready function, needed so we can reset fire rate if its changed by a perk (steady aim)
var starting_max_recoil: float
var starting_recoil_min_increase_factor
var starting_recoil_reduction_amount: int

func _ready():
	assert(fire_type != "", "Gun doesnt have a fire type selected.")
	assert(WEAPON_NAME != "", "Gun doesnt have a name set.: " + WEAPON_NAME)
	if (bullet_type == "projectile"):
		assert(bullet, "Bullet not assigned for gun.")
	if (bullet_type == "ray_cast"):
		assert(bullet_ray_cast, "Bullet raycast not assigned for gun.")
	if (fire_type == "continuous"):
		assert(bullet_type=="ray_cast", 'Continuous firing guns need to use raycast bullets')
	
	bullets_in_clip = clip_size
	bullet_reserve = max_bullet_reserve
	
	# Track starting values for when they are modified
	starting_bullet_damage = bullet_damage
	starting_fire_rate = fire_rate
	starting_recoil_per_shot = reticle.recoil_per_shot
	starting_max_recoil = reticle.gun_recoil_max
	starting_recoil_min_increase_factor = reticle.recoil_min_increase_factor

func clear_modifiers():
	fire_rate = starting_fire_rate
	reticle.recoil_per_shot = starting_recoil_per_shot

func set_modifiers(modifiers: Array):
	for modifier in modifiers:
		match modifier:
			"RAPID_FIRE":
				fire_rate = starting_fire_rate * 0.5  # doubles the fire rate ( by halving the fire rate COOLDOWN )
			"STEADY_AIM":
				reticle.recoil_per_shot = starting_recoil_per_shot * 0.5  # how much recoil increases per shot
				reticle.gun_recoil_max = starting_max_recoil / 2  # max recoil
				reticle.recoil_min_increase_factor = starting_recoil_min_increase_factor / 2.0  # how much min value increases when moving
			_:
				assert(false, "Adding a modifier that isnt handled in this match statement: " + modifier)

func refill_ammo():
	bullets_in_clip = clip_size
	bullet_reserve = max_bullet_reserve

func start_reload():
	"""
	The weapon manager checks if the clip is full and if there is reserve ammo before
	calling this function. This function is called when the reload animations starts.
	"""
	# Play the audio
	audio.play_audio_reload_start()

	# Spawn a magazine
	if magazine_ejection_type == 0:  # spawn magazine on reload
		magazine_spawner.spawn_item(global_rotation)
	
	if shell_ejection_type == "on_reload":  # on_reload
		bullet_shell_spawner.spawn_item(global_rotation)

func finish_reload() -> void:
	"""
	This function is called when the reload animations ends. See start_reload() for 
	information on how the weapon manager calls these functions.
	"""

	audio.play_audio_reload_finished()

	var bullet_needed_to_fill_clip = clip_size - bullets_in_clip
	
	if bullet_reserve >= clip_size:
		bullet_reserve -= bullet_needed_to_fill_clip
		bullets_in_clip += bullet_needed_to_fill_clip
	else:
		bullets_in_clip += bullet_reserve
		bullet_reserve = 0

func shoot() -> void:
	"""
	The player shoot state will check 'can_shoot' before it calls this function since
	the state will dictate the animations.
	"""

	# Track shots
	Events.emit_signal("bullet_fired")

	
	# Play audio
	audio.play_audio_shoot_gun_shot()

	# Spawn vfx's
	if shell_ejection_type == "on_fire":  # on_shoot
		bullet_shell_spawner.spawn_item(global_rotation)
	var muzzle_flash = muzzle_flash_vfx.instantiate()
	muzzle_flash.global_position = muzzle_position.global_position
	muzzle_flash.global_rotation = global_rotation
	ObjectRegistry.register_effect(muzzle_flash)
	
	fire_timer.start(fire_rate)
	bullets_in_clip -= 1

	var recoil_rotation = reticle.calc_recoil_rotation(global_position)
	reticle.apply_bullet_recoil()
	
	# Screen shake - The larger the recoil, the larger the screen shake
	Events.emit_signal("shake_screen", 3 + .05 * reticle.recoil_max, .1)
	
	# Player knockback in the opposite direction as the bullet direction calculation, the large the recoil the larger the knockback
	Events.emit_signal("player_knockback", Vector2(1,0).rotated(global_rotation + recoil_rotation - deg_to_rad(180)) * 1 * reticle.recoil_max)
	
	# The parent of the gun is always the weapon manager, and the player is the owner of that
	# Owner only gets the root parent of a node as it exists in the scene tree
	# since the gun is not a part of the scene tree (its added via code) 
	# we have to use get_parent() instead.
	var shooter = get_parent().owner
	
	var random_bullet_id = Globals.get_random_number(1000)

	# we can ignore spread
	if bullets_per_fire == 1:
		var bullet_direction = Vector2(1,0).rotated(global_rotation + recoil_rotation)
		var spawn_position = muzzle_position.global_position
		
		# Projectile
		if bullet_type == "projectile":
			var bullet_instance = bullet.instantiate()
			ObjectRegistry.register_projectile(bullet_instance)
			bullet_instance.init(bullet_damage, shooter, bullet_knockback, weapon_level, random_bullet_id, has_penetrating_shots)
			bullet_instance.start(spawn_position, bullet_direction, bullet_speed)
		elif bullet_type == "ray_cast":
			bullet_ray_cast.shoot()
		elif bullet_type == "continuous":
			if !trigger_held:
				trigger_held = true
				bullet_ray_cast.shoot()

	# we cannot ignore spread ( like a shot gun )
	else:
		if bullet_spread == 0:
			assert(false, "Spread shouldnt be zero for a gun firing multiple shots or gun will do more damage then intended.")
		
		var bullet_rotation = global_rotation + (bullet_spread / 2)
		var spawn_position = muzzle_position.global_position
		var rotation_direction = 1
		
		# Although we are shooting multiple bullets in one shot, we treat this as one bullet in the clip
		# like a shotgun buck shot
		for i in bullets_per_fire:
			if bullet_type == "projectile":
				var bullet_direction = Vector2(1,0).rotated(bullet_rotation)
				
				var bullet_instance = bullet.instantiate()
				ObjectRegistry.register_projectile(bullet_instance)
				bullet_instance.init(bullet_damage, shooter, bullet_knockback, weapon_level, random_bullet_id, has_penetrating_shots)
				bullet_instance.start(spawn_position, bullet_direction, bullet_speed)
				
				rotation_direction *= -1
				bullet_rotation += bullet_spread * (i+1) * rotation_direction
			elif bullet_type == "ray_cast":
				assert(false, 'Raycast bullets should only fire one bullet per shot')
				bullet_ray_cast.shoot()

func set_gun_level(weapon_level: int) -> void:
	"""
	Determins how each gun is affected by level ups
	"""
	match weapon_level:
		1:
			bullet_damage = starting_bullet_damage * 1.5
		2:
			bullet_damage += starting_bullet_damage * 2.0
		3:
			bullet_damage += starting_bullet_damage * 3.0
	
	audio.level_up(weapon_level)
	self.weapon_level = weapon_level
	Events.emit_signal("player_equipped_change", WEAPON_NAME, weapon_level)

func can_shoot() -> bool:
	"""
	Called by the player's shoot state to check if it should shoot.
	"""
	# TODO - the shoot state should call these checks separetly since the fire_timer
	# shouldnt be tied to the animation
	# ill re-do the animation system later
	if !fire_timer.is_stopped():
		return false
	if bullets_in_clip == 0:
		play_no_ammo_sound()
		return false
	return true

func play_no_ammo_sound():
	"""
	Called by the player's action state machine on reload since that is where the check
	for ammo is called if the player trys to reload. Its the same sound used when the gun
	is trying to be fired with no ammo in the clip.
	"""
	audio.play_audio_shoot_empty_clip()

func is_ammo_full() -> bool:
	return bullets_in_clip == clip_size and bullet_reserve == max_bullet_reserve

# Controled by weapon manager when switching weapons
func toggle_crosshairs(value: bool):
	reticle.visible = value
func toggle_raycast(value: bool):
	lower_weapon_ray_cast.enabled = value

func release_trigger():
	print('gun releasing trigger')
	trigger_held = false
	if fire_type == "continuous":
		print('stoping ray cast')
		bullet_ray_cast.stop()
