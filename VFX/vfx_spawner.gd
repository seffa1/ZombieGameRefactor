extends Node2D

"""
Spawns a single RIGID BODY packed scenes and gives thems a variable impulse to make them look realistic.
Basically a little particle system that can emit objects one-by-one or set to continuous.
"""
@export_group('Single Item Spawning')

@export var object_to_spawn: PackedScene  
@export var item_ejection_speed: float = 600.0  # impulse multiplier applied to item on ejection
@export var item_ejection_speed_variance: float = .6  # percentage
@export var item_ejection_angle_variance: float = 1  # random direction applied to item on ejection
@export var item_rotation_variance: float = 0  # change the rotation of the spawn item in radians
@export var item_ejection_torque: float = 100000  # angular momentum applied to item on ejection
@export var item_ejection_torque_variance: float = 50000

@export_group('Multi-Item Spawning')
## MUST BE A RIGID BODY!!!!
@export var objects_to_spawn: Array[PackedScene]

func spawn_item(rotation: float):
	"""
	Doesn't actually need to be a bullet item but DOES NEED TO BE A RIGID BODY. 
	Spawns objects and sends them out in one direction.
	with some variance, like how a bullet item would eject from a gun.
	"""
	var instance = object_to_spawn.instantiate()

	instance.global_position = global_position
	instance.global_rotation = rotation + randf_range(-item_rotation_variance, item_rotation_variance)

	ObjectRegistry.register_effect(instance)
	
	var impulse_speed = item_ejection_speed + (item_ejection_speed * randf_range(-item_ejection_speed_variance, item_ejection_speed_variance))
	var impulse_direction = rotation + randf_range(-item_ejection_angle_variance, item_ejection_angle_variance)
	var impulse_vector = Vector2.DOWN.rotated(impulse_direction) * impulse_speed

	instance.apply_impulse(impulse_vector)
	instance.apply_torque(item_ejection_torque + randf_range(-item_ejection_torque_variance, item_ejection_torque_variance))
	

func spawn_items_outwards(rotation_offset: float=0.0):
	"""
	Takes all items in 'objects_to_spawn' and evenly dispearses them out in all directions. 
		Rotation_offset will change the rotation of the dispersion
	"""
	print("SPAWNING OUTWARDS ----- ")
	var item_rotation = rotation_offset
	var rotation_delta = deg_to_rad(360) / len(objects_to_spawn)
	print("DELTA: ")
	print(rotation_delta)

	for i in range(len(objects_to_spawn)):
		print('CLUSTER')
		print(item_rotation)
		var instance = objects_to_spawn[i].instantiate()
		instance.global_position = global_position
		instance.global_rotation = item_rotation
		ObjectRegistry.register_effect(instance)
		
		var impulse_speed = item_ejection_speed + (item_ejection_speed * randf_range(-item_ejection_speed_variance, item_ejection_speed_variance))
		var impulse_direction = item_rotation + randf_range(-item_ejection_angle_variance, item_ejection_angle_variance)
		var impulse_vector = Vector2.DOWN.rotated(impulse_direction) * impulse_speed
		
		instance.apply_impulse(impulse_vector)
		instance.apply_torque(item_ejection_torque + randf_range(-item_ejection_torque_variance, item_ejection_torque_variance))

		item_rotation += rotation_delta

