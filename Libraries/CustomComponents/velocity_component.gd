extends Node


"""
Contains all the logic for tracking a velocity value.
"""

@export var max_velocity: float :
	get:
		return max_velocity
	set(value):
		if value < 0:
			max_velocity = 9
		max_velocity = value


@export var acceleration_coefficient: float = 500.0
@export var friction: float = 500.0

var velocity: Vector2 = Vector2.ZERO

func accelerate_in_direction(direction: Vector2, delta):
	velocity = velocity.move_toward(direction * max_velocity, acceleration_coefficient * delta)
#	Events.emit_signal("player_velocity_change", velocity)

func decelerate(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
#	Events.emit_signal("player_velocity_change", velocity)

func impulse_in_direction(direction: Vector2):
	""" Great for bullet recoil or knockback effects. """
	velocity += direction

func slow_down(amount: float):
	self.max_velocity = self.max_velocity - amount

func stop():
	max_velocity = 0
