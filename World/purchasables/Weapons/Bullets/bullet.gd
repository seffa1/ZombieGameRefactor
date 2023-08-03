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
@onready var life_span: Timer = $Lifespan


func init(bullet_damage: int, bullet_shooter: CharacterBody2D):
	hit_box_component.damage = bullet_damage
	hit_box_component.shooter = bullet_shooter

func start(position, direction, speed):
	global_position = position
	rotation = direction.angle()
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	var motion_vector = velocity * delta
	var collision := move_and_collide(motion_vector)
	
	# Check if it collided with the environment
	if collision:
		# TODO - bullet collision fx based on tile type it collided with
		die()

func die() -> void:
	queue_free()

func _on_lifespan_timeout():
	die()
