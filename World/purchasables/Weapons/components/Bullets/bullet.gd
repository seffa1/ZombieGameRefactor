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
@onready var impact_component: Node2D = $HitBoxComponent/Impact_Component

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

@onready var explosion_scene = preload("res://VFX/explosions/Explosion.tscn")

var is_penetrating_shot: bool = false

var smoke_trail
var weapon_level: int

func _ready():
	hit_box_component.enemy_hit.connect(_handle_enemy_hit)

func init(bullet_damage: int, bullet_shooter: CharacterBody2D, bullet_knockback: float, weapon_level: int, random_id: int, is_penetrating_shot: bool=false):
	hit_box_component.damage = bullet_damage
	hit_box_component.shooter = bullet_shooter
	hit_box_component.bullet_knockback = bullet_knockback
	hit_box_component.random_id = random_id
	is_penetrating_shot = is_penetrating_shot
	self.weapon_level = weapon_level

func start(position, direction, speed):
	global_position = position
	rotation = direction.angle()
	velocity = direction * speed

	# VFX
	smoke_trail = get_smoke_trail()
	ObjectRegistry.register_effect(smoke_trail)

func get_smoke_trail():
	"""
	0 = weapon level 1 (base) 
	1 = weapon level 2 (first upgrade)
	2 = weapon level 3 (second upgrade)
	3 = weapon level 4 (third upgrade)
	"""
	match weapon_level:
		0:
			return smoke_trail_scene_level_1.instantiate()
		1:
			return smoke_trail_scene_level_2.instantiate()
		2:
			return smoke_trail_scene_level_3.instantiate()
		3:
			return smoke_trail_scene_level_4.instantiate()
		_:
			assert(false, "Weapon level not in match statement - " + str(weapon_level))

func get_smoke_puff():
	"""
	0 = weapon level 1 (base) 
	1 = weapon level 2 (first upgrade)
	2 = weapon level 3 (second upgrade)
	3 = weapon level 4 (third upgrade)
	"""
	match weapon_level:
		0:
			return smoke_puff_scene_level_1.instantiate()
		1:
			return smoke_puff_scene_level_2.instantiate()
		2:
			return smoke_puff_scene_level_3.instantiate()
		3:
			return smoke_puff_scene_level_4.instantiate()
		_:
			assert(false, "Weapon level not in match statement - " + str(weapon_level))

func _physics_process(delta: float) -> void:
	# Add smoke trail point
	# The bullet's lifespan must be longer than the smokes or this will error out !
	smoke_trail.add_point(global_position)
	var motion_vector = velocity * delta
	var collision := move_and_collide(motion_vector)

	# Check if it collided with the environment
	if collision:
		# TODO - bullet collision fx based on tile type it collided with
		var smoke_puff = get_smoke_puff()
		smoke_puff.global_position = global_position
		smoke_puff.rotation = rotation + deg_to_rad(180)
		ObjectRegistry.register_effect(smoke_puff)
		die()

func _handle_enemy_hit():
	if impact_component.impact_type == "impact" and !is_penetrating_shot:
		die()
	if impact_component.impact_type == "explosion":
		create_explosion()
	if impact_component.impact_type == "lightning":
		die()

func create_explosion():
	# Create the explosion
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.rotation = rotation
	explosion.initialize([7, 8, 9])
	ObjectRegistry.register_effect(explosion)
	die()

func die() -> void:
	queue_free()

func _on_lifespan_timeout():
	die()
