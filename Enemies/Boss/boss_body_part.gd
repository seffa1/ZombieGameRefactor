extends Node2D

@export var animated_sprites: Array[AnimatedSprite2D]

func _ready():
	Events.boss_death.connect(_on_boss_death)
	
func _on_boss_death():
	for animated_sprite in animated_sprites:
		animated_sprite.play()

func _on_animated_sprite_2d_animation_finished():
	for animated_sprite in animated_sprites:
		animated_sprite.pause()

func handle_imuplse(impulse_vector: Vector2):
	$SpawnInAnimator.apply_impulse(impulse_vector)
	
func handle_torque(torque: float):
	$SpawnInAnimator.apply_torque(torque)
