extends CharacterBody2D

"""
Base class for different bullets.
Guns are assigned a bullet as an export var. Different bullets exists only to vary
the visual appearance/VFX's. The properties of the bullet are set by the gun when the 
gun shoots with the init function.

This class can be used as a generic bullet. If you want to make a bullet with different fx, inherit from this
and change the fx.
"""

const _IMPACT_SAMPLES = [
 # TODO
]

@onready var life_span: Timer = $Lifespan

# Variables
var damage: int:
	get:
		return damage
	set(value):
		damage = value

var shooter: CharacterBody2D:  # reference back to the player
	get:
		return shooter
	set(value):
		shooter = value

func init(bullet_damage: int, bullet_shooter: CharacterBody2D):
	damage = bullet_damage
	shooter = bullet_shooter

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
		print("Bullet hit environment")
		die()

func die() -> void:
	queue_free()


func _on_lifespan_timeout():
	die()
