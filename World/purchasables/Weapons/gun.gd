
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
@onready var audio = $Audio
@onready var audio_shoot_empty_clip: AudioStream = preload("res://World/purchasables/Weapons/shared/audio/ESM_FVESK_fx_foley_ui_clip_podracer_steel_gun_empty_clip.wav")
@onready var audio_start_volume = audio.volume_db
@onready var audio_start_pitch = audio.pitch_scale
@onready var reticle = $Reticle
@onready var bullet_spawner = $VFXSpawner

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
@export_enum("on_fire", "on_reload") var shell_ejection_type: int

# TODO - move all the audio code to a separate node
@export var audio_reload_start: AudioStream
@export var audio_reload_finished: AudioStream
@export var audio_shoot_gun_shot: AudioStream   # TODO - make a function that slightly alters the gun shot sounds pitch to make it varied

# Variables
var bullets_in_clip: int:
	set(value):
		bullets_in_clip = value
		Events.emit_signal("player_equipped_clip_count_change", bullets_in_clip)
		
var bullet_reserve: int:
	set(value):
		bullet_reserve = value
		Events.emit_signal("player_equipped_reserve_count_change", bullet_reserve)

func _ready():
	assert(fire_type != "", "Gun doesnt have a fire type selected.")
	assert(WEAPON_NAME != "", "Gun doesnt have a name set.: " + WEAPON_NAME)
	assert(bullet, "Bullet not assigned for gun.")
	
	bullets_in_clip = clip_size
	bullet_reserve = max_bullet_reserve

func refill_ammo():
	bullets_in_clip = clip_size
	bullet_reserve = max_bullet_reserve

func start_reload():
	"""
	The weapon manager checks if the clip is full and if there is reserve ammo before
	calling this function. This function is called when the reload animations starts.
	"""
	_reset_audio_stream()
	audio.stream = audio_reload_start
	audio.play()
	# TODO - spawn a magazine object to place on the ground ( like in Heat Guardian )

func finish_reload() -> void:
	"""
	This function is called when the reload animations ends. See start_reload() for 
	information on how the weapon manager calls these functions.
	"""
	_reset_audio_stream()
	audio.stream = audio_reload_finished
	audio.play()
	
	var bullet_needed_to_fill_clip = clip_size - bullets_in_clip
	
	if bullet_reserve >= clip_size:
		bullet_reserve -= bullet_needed_to_fill_clip
		bullets_in_clip += bullet_needed_to_fill_clip
	else:
		bullets_in_clip += bullet_reserve
		bullet_reserve = 0

func shoot() -> void:
	"""
	Generic function used by all children. Should not need to be re-defined.
	The player shoot state will check 'can_shoot' before it calls this function since
	the state will dictate the animations.
	"""
	# Play audio
	audio.stream = audio_shoot_gun_shot
	_randomize_audio_stream(.04, .9)
	audio.play()
	
	# Spawn vfx's
	if shell_ejection_type == 0:  # on_shoot
		bullet_spawner.spawn_bullet_shell(global_rotation)
	
	fire_timer.start(fire_rate)
	bullets_in_clip -= 1

	var recoil_rotation = _calc_recoil_rotation(reticle.recoil_amount)
#	print(recoil_rotation)
	reticle.apply_bullet_recoil()
	
	# TODO - do we have more intense shake for larger guns ?
	Events.emit_signal("shake_screen", 5, .1)
	
	# The parent of the gun is always the weapon manager, and the player is the owner of that
	# Owner only gets the root parent of a node as it exists in the scene tree
	# since the gun is not a part of the scene tree (its added via code) 
	# we have to use get_parent() instead.
	var shooter = get_parent().owner

	# we can ignore spread
	if bullets_per_fire == 1:
		var bullet_direction = Vector2(1,0).rotated(global_rotation + recoil_rotation)
		var spawn_position = muzzle_position.global_position
		
		var bullet_instance = bullet.instantiate()
		ObjectRegistry.register_projectile(bullet_instance)
		bullet_instance.init(bullet_damage, shooter)
		bullet_instance.start(spawn_position, bullet_direction, bullet_speed)

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
			bullet_instance.init(bullet_damage, shooter)
			bullet_instance.start(spawn_position, bullet_direction, bullet_speed)
			
			rotation_direction *= -1
			bullet_rotation += bullet_spread * (i+1) * rotation_direction

func _calc_recoil_rotation(recoil_amount: float):
	var vector_to_mouse = get_global_mouse_position() - global_position
	
	# vector pointing from mouse to edge of recoil indicator, perpendicular to player
	# 1.57 is 90 deg in radians
	var recoil_vector = vector_to_mouse.normalized().rotated(1.57) * recoil_amount 
	
	# Vector pointing from gun, to the outer edge of the recoil indicator
	var max_recoil_vector = vector_to_mouse + recoil_vector
	
	# Find the angle from the mouse position, to outside of recoil indicator
	var max_recoil_angle = vector_to_mouse.angle_to(max_recoil_vector)
	
	# Choose a random spot within this range on either direction
	return randf_range(-max_recoil_angle, max_recoil_angle)

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
	_reset_audio_stream()
	audio.stream = audio_shoot_empty_clip
	audio.play()

func _randomize_audio_stream(pitch_amount: float, volume_amount: float):
	"""
	Slightly randomizes the pitch and volume of the audio stream player to make for more 
	varied gun shot sounds using just one audio sample. pitch_amount and volume_amount
	is how great the range of variation is.
	"""
	_reset_audio_stream()
	var pitch_variation = randf_range(-pitch_amount, pitch_amount)
	var volume_variation = randf_range(-volume_amount, volume_amount)
	
	audio.pitch_scale += pitch_variation
	audio.volume_db += volume_variation


func _reset_audio_stream():
	audio.volume_db = audio_start_volume
	audio.pitch_scale = audio_start_pitch
	
func is_ammo_full() -> bool:
	return bullets_in_clip == clip_size and bullet_reserve == max_bullet_reserve
