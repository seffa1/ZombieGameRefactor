extends Node2D

"""
Activates all the VFX spawns with slightly different times.
"""

@onready var body_parts = $BodyPartsContainer
@onready var blood_spawner = $BloodSpawner
@onready var impact_audio = $BulletImpacts
@onready var splatter_audio = $BloodSplatters

@onready var body_part_explosion = preload("res://VFX/Gore/particleSystems/AllBodyPartsExplsion.tscn")

# Last global position of the object that damaged the zombie
var last_damage_position: Vector2

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
	# Spawn gore in the direction of the velocity (the -90 is because the vfx spawner defaults to a vector.DOWN
	var angle = (zombie_position - explosion_position).angle()
	
	for body_part_spawner in body_parts.get_children():
		# 50% chance to spawn a body part to add visual variance
		if randf_range(0, 100) > 50:
			body_part_spawner.spawn_item(angle - deg_to_rad(90))

func play_splatter():
	splatter_audio.play_random()

func spawn_body_part_particle_system(zombie_position: Vector2, explosion_position: Vector2):
	"""
	This was a test but is not going to be used. Particles dont make sense for body parts
	since they need to be rigid bodies to be interactable
	"""
	var direction_vector = (zombie_position - explosion_position).normalized()
	var body_part_explosion_vfx = body_part_explosion.instantiate()
	body_part_explosion_vfx.global_position = zombie_position
	body_part_explosion_vfx.rotation = direction_vector.angle()
	ObjectRegistry.register_effect(body_part_explosion_vfx)
