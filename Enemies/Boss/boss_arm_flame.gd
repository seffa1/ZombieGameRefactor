extends Node2D

@onready var flame_particles: GPUParticles2D = %FlamethrowerParticles_Boss
@onready var hitbox: CollisionShape2D = %hitboxCollision
@onready var flame_sound_loop: AudioStreamPlayer2D = %FlameSound
@onready var flame_sound_start: AudioStreamPlayer2D = %StartSound
@onready var flame_sound_stop: AudioStreamPlayer2D = %StopSound

@export var health_component: Node2D

func _ready():
	health_component.health_at_zero.connect(_on_health_at_zero)

func _on_health_at_zero():
	hide()

func _flame_on():
	flame_sound_start.play()
	flame_sound_loop.play()
	flame_particles.emitting = true
	hitbox.disabled = false

func _flame_off():
	flame_sound_loop.stop()
	flame_sound_stop.play()
	flame_particles.emitting = false
	hitbox.disabled = true

