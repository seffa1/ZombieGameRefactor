extends Node2D

@onready var poisen_particle: GPUParticles2D = %PoisenThrow
@onready var spit_attck: PackedScene = preload("res://VFX/poisenSpitAttack/SpitterAttack.tscn")

func _shoot():
	poisen_particle.emitting = true
	var spit_object = spit_attck.instantiate()
	spit_object.global_position = owner.global_position
	spit_object.rotation = owner.rotation
	spit_object.direction = Vector2(1,0).rotated(owner.rotation)
	ObjectRegistry.register_effect(spit_object)
