extends Node2D

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

func _ready():
	Events.boss_death.connect(_on_boss_death)
	
func _on_boss_death():
	animated_sprite.play()

func _on_animated_sprite_2d_animation_finished():
	animated_sprite.pause()
