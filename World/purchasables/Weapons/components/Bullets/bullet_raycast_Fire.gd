extends RayCast2D

@export var particles: GPUParticles2D
@onready var fire_hitbox_collision: CollisionShape2D = %CollisionShape2D
@onready var flame_sounds: AudioStreamPlayer2D = %FlameSound
@onready var animation_player: AnimationPlayer = %AnimationPlayer


var is_firing: bool = false

func shoot():
	is_firing = true
	particles.emitting = true
	fire_hitbox_collision.disabled = false
	animation_player.play("shoot")

func stop():
	if is_firing:
		is_firing = false
		flame_sounds.stop()
		particles.emitting = false
		fire_hitbox_collision.disabled = true
		animation_player.play("stop")

func _on_shoot_animation_finished():
	flame_sounds.play()
	print(flame_sounds.get_stream_playback())
