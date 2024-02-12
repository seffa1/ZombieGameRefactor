extends CharacterBody2D

"""
The properties of the bullet are set by the gun when the 
gun shoots with the init function. That information is passed down to the hitboxComponent so 
a receiving hurtbox and get the information it needs.
"""

const _IMPACT_SAMPLES = [
 # TODO
]

@onready var hit_box_component: Area2D = $HitBoxComponent

# The smoke trails lifespan must be greater than the bullets!
@onready var life_span: Timer = $Lifespan
@onready var smoke_trail_scene_level_1 = preload("res://VFX/smoketrails/Smoketrail.tscn")
@onready var smoke_trail_scene_level_2 = preload("res://VFX/smoketrails/Smoketrail_level_2.tscn")
@onready var smoke_trail_scene_level_3 = preload("res://VFX/smoketrails/Smoketrail_level_3.tscn")
@onready var smoke_trail_scene_level_4 = preload("res://VFX/smoketrails/Smoketrail_level_4.tscn")
@onready var smoke_puff_scene_level_1 = preload("res://VFX/smokePuff/SmokePuff.tscn")
@onready var smoke_puff_scene_level_2 = preload("res://VFX/smokePuff/SmokePuff_level_2.tscn")
@onready var smoke_puff_scene_level_3 = preload("res://VFX/smokePuff/SmokePuff_level_3.tscn")
@onready var smoke_puff_scene_level_4 = preload("res://VFX/smokePuff/SmokePuff_level_4.tscn")


@export_category('Bullet Configs')
@export var is_penetrating_shot: bool = false
@export var is_explosive: bool = false
@export var explosion_scene: PackedScene

var _smoke_trail
var _weapon_level: int
var _bullet_knockback: float

func _ready():
	hit_box_component.enemy_hit.connect(_handle_enemy_hit)

# Parameters passed in by the gun instantiating it
func init(bullet_damage: int, bullet_shooter: CharacterBody2D, bullet_knockback: float, weapon_level: int, random_id: int, is_penetrating_shot: bool=false):
	hit_box_component.damage = bullet_damage
	hit_box_component.shooter = bullet_shooter
	hit_box_component.random_id = random_id
	is_penetrating_shot = is_penetrating_shot
	self._weapon_level = weapon_level
	self._bullet_knockback = bullet_knockback

func start(position, direction, speed):
	global_position = position
	rotation = direction.angle()
	velocity = direction * speed
	
	# Set knockback
	hit_box_component.knockback_vector = velocity.normalized() * _bullet_knockback

	# VFX
	_smoke_trail = get_smoke_trail()
	ObjectRegistry.register_effect(_smoke_trail)

func get_smoke_trail():
	"""
	0 = weapon level 1 (base) 
	1 = weapon level 2 (first upgrade)
	2 = weapon level 3 (second upgrade)
	3 = weapon level 4 (third upgrade)
	"""
	match _weapon_level:
		0:
			return smoke_trail_scene_level_1.instantiate()
		1:
			return smoke_trail_scene_level_2.instantiate()
		2:
			return smoke_trail_scene_level_3.instantiate()
		3:
			return smoke_trail_scene_level_4.instantiate()
		_:
			assert(false, "Weapon level not in match statement - " + str(_weapon_level))

func get_smoke_puff():
	"""
	0 = weapon level 1 (base) 
	1 = weapon level 2 (first upgrade)
	2 = weapon level 3 (second upgrade)
	3 = weapon level 4 (third upgrade)
	"""
	match _weapon_level:
		0:
			return smoke_puff_scene_level_1.instantiate()
		1:
			return smoke_puff_scene_level_2.instantiate()
		2:
			return smoke_puff_scene_level_3.instantiate()
		3:
			return smoke_puff_scene_level_4.instantiate()
		_:
			assert(false, "Weapon level not in match statement - " + str(_weapon_level))

func _physics_process(delta: float) -> void:

	# Add smoke trail point
	# The bullet's lifespan must be longer than the smokes or this will error out !
	_smoke_trail.add_point(global_position)
	var motion_vector = velocity * delta
	var collision := move_and_collide(motion_vector)

	# Check if it collided with the environment
	if collision:
		# TODO - bullet collision fx based on tile type it collided with
		var smoke_puff = get_smoke_puff()
		smoke_puff.global_position = global_position
		smoke_puff.rotation = rotation + deg_to_rad(180)
		ObjectRegistry.register_effect(smoke_puff)
		queue_free()

func _handle_enemy_hit():
	if is_explosive:
		_create_explosion()
	
	# prevents the bullet from being destroyed by enemy hits
	if is_penetrating_shot:
		return
		
	queue_free()

func _create_explosion():
	# Create the explosion
	var _explosion = explosion_scene.instantiate()
	_explosion.global_position = global_position
	_explosion.rotation = rotation
	_explosion.initialize([7, 8, 9])
	ObjectRegistry.register_effect(_explosion)
	queue_free()

func _on_lifespan_timeout():
	queue_free()
