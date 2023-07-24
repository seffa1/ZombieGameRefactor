extends CharacterBody2D

"""
Base class for different bullets. Only inherited classes should be used by guns.
Guns are assigned a bullet as an export var. Different bullets exists only to vary
the visual appearance/VFX's. The properties of the bullet are set by the gun when the 
gun shoots with the init function.
"""

# Variables
var speed: float = 1500.0
var damage: int = 10
var direction: Vector2 = Vector2.ZERO
var shooter: CharacterBody2D  # reference back to the player

func init(
	damage: int, 
	speed: int,
	shooter: CharacterBody2D, 
	spawn_position: Vector2, 
	direction
	):
	"""
	Bullet properties set by the gun when it shoots.
	"""
	damage = damage
	speed = speed
	shooter = shooter
	position = spawn_position
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	var collision := move_and_collide(direction * speed * delta)
	if collision:
		Events.emit_signal("damaged", collision.collider, damage, shooter)
		die()

func die() -> void:
	queue_free()
