extends Node2D


"""
Spawns a packed scene at its position and puts it in the object registry.
Used to spawn in vfx's in the animation player.
- animate the position, rotation, and spawn_item() call method
"""

@export var object_to_spawn: PackedScene

func spawn_item():
	var instance = object_to_spawn.instantiate()
	instance.global_position = global_position
	instance.rotation = global_rotation
	ObjectRegistry.register_effect(instance)
