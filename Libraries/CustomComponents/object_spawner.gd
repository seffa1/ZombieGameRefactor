extends Marker2D


"""
Spawns a packed scene at its position and puts it in the object registry.
The simplest way to spawn in a self-freeing effect for exampl.
"""

@export var object_to_spawn: PackedScene

func spawn_item():
	var instance = object_to_spawn.instantiate()
	instance.global_position = global_position
	instance.rotation = global_rotation
	ObjectRegistry.register_effect(instance)
