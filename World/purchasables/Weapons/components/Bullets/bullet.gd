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

@export_category('Bullet Configs')
@export var penetrations: int = 0
@export var is_explosive: bool = false
@export var explosion_scene: PackedScene
@export var smoke_trail_scene: PackedScene
@export var smoke_puff_scene: PackedScene

var _smoke_trail
var _weapon_level: int
var _bullet_knockback: float
var _enemies_hit: int = 0
var _RIDs_struct: Array = []

func _ready():
	hit_box_component.enemy_hit.connect(_handle_enemy_hit)

# Parameters passed in by the gun instantiating it
func init(bullet_damage: int, bullet_shooter: CharacterBody2D, bullet_knockback: float, weapon_level: int, random_id: int, penetrations: int):
	hit_box_component.damage = bullet_damage
	hit_box_component.shooter = bullet_shooter
	hit_box_component.random_id = random_id
	self.penetrations = penetrations
	self._weapon_level = weapon_level
	self._bullet_knockback = bullet_knockback

func start(position, direction, speed):
	global_position = position
	rotation = direction.angle()
	velocity = direction * speed
	
	# Set knockback
	hit_box_component.knockback_vector = velocity.normalized() * _bullet_knockback

	# VFX
	_smoke_trail = smoke_trail_scene.instantiate()
	ObjectRegistry.register_effect(_smoke_trail)

func _physics_process(delta: float) -> void:

	# Add smoke trail point
	# The bullet's lifespan must be longer than the smokes or this will error out !
	_smoke_trail.add_point(global_position)
	var motion_vector = velocity * delta
	var collision := move_and_collide(motion_vector)

	# Check if it collided with the environment
	if collision:
		# TODO - bullet collision fx based on tile type it collided with
		var smoke_puff = smoke_puff_scene.instantiate()
		smoke_puff.global_position = global_position
		smoke_puff.rotation = rotation + deg_to_rad(180)
		ObjectRegistry.register_effect(smoke_puff)
		queue_free()

func _new_enemy_struct(RID: RID):
	return _RIDs_struct.find(RID) == -1

func _handle_enemy_hit(_enemy_hurt_box: Area2D):
	if is_explosive:
		_create_explosion()
	
	if penetrations == 0:
		queue_free()
	
	# Destroy bullet when the penetrations limit is reached
	if _enemies_hit > penetrations:
		queue_free()

	# Track unique enemy hits ( instead of unique hurtbox hits )
	var enemyRID = _enemy_hurt_box.owner.get_rid()

	if _new_enemy_struct(enemyRID):
		_RIDs_struct.append(enemyRID)
		_enemies_hit += 1

func _create_explosion():
	# Create the explosion
	var _explosion = explosion_scene.instantiate()
	_explosion.global_position = global_position
	_explosion.rotation = rotation
	_explosion.initialize([0, 1, 2, 3, 4])
	ObjectRegistry.register_effect(_explosion)
	queue_free()

func _on_lifespan_timeout():
	queue_free()
