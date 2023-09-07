extends Node2D

# Used by the throwable to access the shooter variable of the hitbox
@onready var hitbox_component = $HitBoxComponent

func set_player(player: CharacterBody2D):
	hitbox_component.shooter = player
