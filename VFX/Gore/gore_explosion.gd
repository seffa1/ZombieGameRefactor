extends Node2D

"""
Activates all the VFX spawns with slightly different times.
"""

@onready var body_parts = $BodyPartsContainer

var last_damage_position: Vector2

func zombie_death(velocity: Vector2):
	"""
	VFX for a generic zombie death.
	"""
	
	# Spawn gore in the direction
	for body_part_spawner in body_parts.get_children():
		body_part_spawner.spawn_item(velocity.angle() - deg_to_rad(90))
	
func bullet_impact(velocity: Vector2):
	"""
	VFX for a bullet hit.
	"""
	print("bullet hit")
	return
