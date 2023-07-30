extends Node


"""
Contains all the logic for tracking a velocity value.
"""

@export var max_velocity: float
@export var acceleration_coefficient: float

var velocity: Vector2 = Vector2.ZERO

func accelerate_in_direction(direction: Vector2):
	# TODO - add acceleration_coefficient to the equation
	velocity = direction

func decelerate():
	# TODO
	return
