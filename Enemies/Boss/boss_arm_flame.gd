extends Node2D

@onready var flame_particles: GPUParticles2D = %FlamethrowerParticles_Upgrade_V2
@onready var hitbox: CollisionShape2D = %hitboxCollision

func _flame_on():
	flame_particles.emitting = true
	hitbox.disabled = false

func _flame_off():
	flame_particles.emitting = false
	hitbox.disabled = true

