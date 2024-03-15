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
