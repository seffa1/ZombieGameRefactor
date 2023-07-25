extends CharacterBody2D

"""
Base class for different bullets.
Guns are assigned a bullet as an export var. Different bullets exists only to vary
the visual appearance/VFX's. The properties of the bullet are set by the gun when the 
gun shoots with the init function.

This class can be used as a generic bullet. If you want to make a bullet with different fx, inherit from this
and change the fx.
"""

# Variables
var speed: float
var damage: int
var direction: Vector2 = Vector2.ZERO
var shooter: CharacterBody2D  # reference back to the player

func init(damage: int, shooter: CharacterBody2D):
	damage = damage
	speed = speed
	shooter = shooter

func start(position, direction, speed):
	
	global_position = position
	print(position)
	rotation = direction.angle()
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	var motion_vector = velocity * delta
	#print(direction.rotated(rotation))
	#print("updated bullet: " + str(motion_vector))
	#print("delta: " + str(delta))
	#sprint("direction: " + str(direction))
	#print("speed: " + str(speed))
	var collision := move_and_collide(motion_vector)
	if collision:
		Events.emit_signal("damaged", collision.collider, damage, shooter)
		die()

func die() -> void:
	queue_free()
