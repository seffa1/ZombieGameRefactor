extends Node2D

@onready var flame_particles: GPUParticles2D = %FlamethrowerParticles_Boss
@onready var hitbox: CollisionShape2D = %hitboxCollision
@onready var flame_sound_loop: AudioStreamPlayer2D = %FlameSound
@onready var flame_sound_start: AudioStreamPlayer2D = %StartSound
@onready var flame_sound_stop: AudioStreamPlayer2D = %StopSound

@export var health_component: Node2D

var flame_arm_destroyed: bool = false

func _ready():
	health_component.health_at_zero.connect(_on_health_at_zero)

func _on_health_at_zero():
	flame_arm_destroyed = true
	flame_sound_loop.stop()
	flame_sound_stop.stop()
	hitbox.set_deferred("disabled", "true")
	flame_particles.emitting = false
	hide()

func _flame_on():
	if flame_arm_destroyed:
		return
	flame_sound_start.play()
	flame_sound_loop.play()
	flame_particles.emitting = true
	hitbox.disabled = false

func _flame_off():
	if flame_arm_destroyed:
		return
	flame_sound_loop.stop()
	flame_sound_stop.play()
	flame_particles.emitting = false
	hitbox.disabled = true

