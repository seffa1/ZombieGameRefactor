extends Node


"""
Contains all the logic for tracking a velocity value.
"""

@export var max_velocity: float :
	get:
		return max_velocity
	set(value):
		print("Setting Velocity")
		print(value)
		if value < 0:
			max_velocity = 0
		max_velocity = value

@export var acceleration_coefficient: float = 500.0
@export var friction: float = 500.0

var velocity: Vector2 = Vector2.ZERO

var saved_velocity_stack: Array[float]
var previous_max_velocity: float = 0.0

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

func stop():
	previous_max_velocity = max_velocity
	self.max_velocity = 0

func start():
	self.max_velocity = previous_max_velocity

func save_max_velocity():
	saved_velocity_stack.push_front(self.max_velocity)

func load_max_velocity():
	if len(saved_velocity_stack) > 0:
		self.max_velocity = saved_velocity_stack[0]
