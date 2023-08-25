extends Marker2D


"""
Spawns a packed scene at its position. Useful for spawning self-freeing objects
during animation. Just animate the position / rotation of this marker and call the spawn_item method.
"""

@export var object_to_spawn: PackedScene  # MUST BE A RIGID BODY!!!!


func spawn_item():
	"""
	Doesn't actually need to be a bullet item but DOES NEED TO BE A RIGID BODY. 
	Spawns objects and sends them out in one direction.
	with some variance, like how a bullet item would eject from a gun.
	"""
	var instance = object_to_spawn.instantiate()
	instance.global_position = global_position
	instance.rotation = global_rotation
	ObjectRegistry.register_effect(instance)
