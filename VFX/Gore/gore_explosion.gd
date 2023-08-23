extends Node2D

"""
Activates all the VFX spawns with slightly different times.
"""

@onready var body_parts = $BodyPartsContainer
@onready var blood_spawner = $BloodSpawner
@onready var impact_audio = $BulletImpacts
@onready var splatter_audio = $BloodSplatters

# Last global position of the object that damaged the zombie
var last_damage_position: Vector2

func zombie_death():
	"""
	VFX for a generic zombie death.
	"""
	play_splatter()
	var angle = (last_damage_position - global_position).angle()
	
	# Spawn gore in the direction of the velocity (the -90 is because the vfx spawner defaults to a vector.DOWN
	for body_part_spawner in body_parts.get_children():
		body_part_spawner.spawn_item(angle - deg_to_rad(-270))

func bullet_impact(velocity: Vector2):
	"""
	VFX for a bullet hit.
	"""
	blood_spawner.spawn_item(velocity.angle()  - deg_to_rad(90))
	impact_audio.play_random()

func play_splatter():
	splatter_audio.play_random()
