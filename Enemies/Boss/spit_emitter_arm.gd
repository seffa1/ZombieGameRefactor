extends Node2D

@onready var poisen_particle: GPUParticles2D = %PoisenThrow
@onready var dripping_particles: GPUParticles2D = %DrippingParticles
@onready var spit_attck: PackedScene = preload("res://VFX/poisenSpitAttack/SpitterAttack_Boss.tscn")

@export var health_component: Node2D

var spit_arm_destroyed: bool = false


func _ready():
	health_component.health_at_zero.connect(_on_health_at_zero)

func _on_health_at_zero():
	spit_arm_destroyed = true
	dripping_particles.emitting = false
	hide()

func _shoot():
	if spit_arm_destroyed:
		return
	poisen_particle.emitting = true
	var spit_object = spit_attck.instantiate()
	spit_object.global_position = global_position
	spit_object.global_rotation = global_rotation
	spit_object.direction = Vector2(1,0).rotated(global_rotation)
	ObjectRegistry.register_effect(spit_object)
	
	Events.emit_signal("shake_screen", 15, .1)
