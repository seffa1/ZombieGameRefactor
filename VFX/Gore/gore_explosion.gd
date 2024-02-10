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

var has_exploded: bool = false

func zombie_death():
	"""
	VFX for a generic zombie death.
	"""
	play_splatter()
	var angle = (global_position - last_damage_position).angle()
	
	# Spawn gore in the direction of the velocity (the -90 is because the vfx spawner defaults to a vector.DOWN
	for body_part_spawner in body_parts.get_children():
		body_part_spawner.spawn_item(angle - deg_to_rad(90))

func bullet_impact(velocity: Vector2):
	"""
	VFX for a bullet hit.
	"""
	blood_spawner.spawn_item(velocity.angle()  - deg_to_rad(90))
	impact_audio.play_random()

func explosion_death(zombie_position: Vector2, explosion_position: Vector2):
	# prevents multiple explosive deaths when two hit boxes kill at the same time (lighting arc causes this)
	if has_exploded:
		return
	has_exploded = true
	# Spawn gore in the direction of the velocity (the -90 is because the vfx spawner defaults to a vector.DOWN
	var angle = (zombie_position - explosion_position).angle()
	
	for body_part_spawner in body_parts.get_children():
		# 50% chance to spawn a body part to add visual variance
		if randf_range(0, 100) > 50:
			body_part_spawner.spawn_item(angle - deg_to_rad(90))

func play_splatter():
	splatter_audio.play_random()

