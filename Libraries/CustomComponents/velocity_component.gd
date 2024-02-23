extends Node


"""
Contains all the logic for tracking a velocity value.
"""

@export var max_velocity: float :
	get:
		return max_velocity
	set(value):
		if value < 0:
			max_velocity = 0
		max_velocity = value

@export var acceleration_coefficient: float = 500.0
@export var friction: float = 500.0

var velocity: Vector2 = Vector2.ZERO

var saved_velocity_stack: Array[float]

func accelerate_in_direction(direction: Vector2, delta):
	velocity = velocity.move_toward(direction * max_velocity, acceleration_coefficient * delta)
#	Events.emit_signal("player_velocity_change", velocity)

func decelerate(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
#	Events.emit_signal("player_velocity_change", velocity)

func impulse_in_direction(direction: Vector2):
	""" Great for bullet recoil or knockback effects. """
	velocity += direction

func reduce_max(amount: float):
	self.max_velocity = self.max_velocity - amount

func raise_max(amount: float):
	self.max_velocity = self.max_velocity + amount

