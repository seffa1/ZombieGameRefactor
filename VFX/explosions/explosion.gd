extends Node2D

# Used by the throwable to access the shooter variable of the hitbox
@onready var hitbox_component = $HitBoxComponent
@onready var animation_player = $AnimationPlayer

@export var no_damage: bool = false


var animations = [
	"default",
	"new_animation",
	"new_animation_1",
	"new_animation_2",
	"new_animation_3",
	"new_animation_4",
	"new_animation_5",
	"new_animation_6",
	"new_animation_7",
	"new_animation_8",
]

func set_player(player: CharacterBody2D):
	hitbox_component.shooter = player

# Args should be an array of animations (indexs) to pick from the animations array
func play_random_explosion(args):
	var animation_index = args.pick_random()
	$AnimatedSprite2D2.play(animations[animation_index])
	
	if no_damage:
		$AnimationPlayer.play("explode_no_damage")
	else:
		$AnimationPlayer.play("explode")
	
