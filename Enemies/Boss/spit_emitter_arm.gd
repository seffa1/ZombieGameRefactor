extends Node2D

@onready var poisen_particle: GPUParticles2D = %PoisenThrow
@onready var spit_attck: PackedScene = preload("res://VFX/poisenSpitAttack/SpitterAttack_Boss.tscn")

func _shoot():
	poisen_particle.emitting = true
	var spit_object = spit_attck.instantiate()
	spit_object.global_position = global_position
	spit_object.global_rotation = global_rotation
	spit_object.direction = Vector2(1,0).rotated(global_rotation)
	ObjectRegistry.register_effect(spit_object)
