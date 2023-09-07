extends CharacterBody2D

"""
Base class for different bullets.
Guns are assigned a bullet as an export var. Different bullets exists only to vary
the visual appearance/VFX's. The properties of the bullet are set by the gun when the 
gun shoots with the init function. That information is passed down to the hitboxComponent so 
a receiving hurtbox and get the information it needs.
"""

const _IMPACT_SAMPLES = [
 # TODO
]

@onready var hit_box_component = $HitBoxComponent

# The smoke trails lifespan must be greater than the bullets!
@onready var life_span: Timer = $Lifespan
@onready var smoke_trail_scene = preload("res://VFX/smoketrails/Smoketrail.tscn")
@onready var smoke_puff_scene = preload("res://VFX/smokePuff/SmokePuff.tscn")
var smoke_trail

func init(bullet_damage: int, bullet_shooter: CharacterBody2D, bullet_knockback: float):
	hit_box_component.damage = bullet_damage
	hit_box_component.shooter = bullet_shooter
	hit_box_component.bullet_knockback = bullet_knockback

func start(position, direction, speed):
	global_position = position
	rotation = direction.angle()
	velocity = direction * speed
	
	# VFX
	smoke_trail = smoke_trail_scene.instantiate()
	ObjectRegistry.register_effect(smoke_trail)

func _physics_process(delta: float) -> void:
	# Add smoke trail point
	# The bullet's lifespan must be longer than the smokes or this will error out !
	smoke_trail.add_point(global_position)
	var motion_vector = velocity * delta
	var collision := move_and_collide(motion_vector)

	# Check if it collided with the environment
	if collision:		
		# TODO - bullet collision fx based on tile type it collided with
		var smoke_puff = smoke_puff_scene.instantiate()
		smoke_puff.global_position = global_position
		smoke_puff.rotation = rotation + deg_to_rad(180)
		ObjectRegistry.register_effect(smoke_puff)
		die()

func die() -> void:
	queue_free()

func _on_lifespan_timeout():
	die()