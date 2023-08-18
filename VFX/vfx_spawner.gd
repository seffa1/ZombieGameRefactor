extends Node2D

"""
Spawns RIGID BODY packed scenes and gives thems a variable impulse to make them look realistic.
Basically a little particle system that can emit objects one-by-one or set to continuous.
"""

@export var object_to_spawn: PackedScene  # MUST BE A RIGID BODY!!!!
@export var continuous: bool = false  # if set to true

@export var shell_ejection_speed: float = 600.0  # impulse multiplier applied to shell on ejection
@export var shell_ejection_speed_variance: float = .6  # percentage
@export var shell_ejection_angle_variance: float = 1  # random rotation applied to shell on ejection
@export var shell_ejection_torque: float = 100000
@export var shell_ejection_torque_variance: float = 50000

func spawn_bullet_shell(rotation: float):
	"""
	Doesn't actually need to be a bullet shell but DOES NEED TO BE A RIGID BODY. 
	Spawns objects and sends them out in one direction.
	with some variance, like how a bullet shell would eject from a gun.
	"""
	var instance = object_to_spawn.instantiate()
	instance.global_position = global_position
	instance.global_rotation = rotation
	ObjectRegistry.register_effect(instance)
	
	var impulse_speed = shell_ejection_speed + (shell_ejection_speed * randf_range(-shell_ejection_speed_variance, shell_ejection_speed_variance))
	var impulse_direction = rotation + randf_range(-shell_ejection_angle_variance, shell_ejection_angle_variance)
	var impulse_vector = Vector2.DOWN.rotated(impulse_direction) * impulse_speed

	instance.apply_impulse(impulse_vector)
	instance.apply_torque(shell_ejection_torque + randf_range(-shell_ejection_torque_variance, shell_ejection_torque_variance))
	
