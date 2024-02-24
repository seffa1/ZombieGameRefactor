extends Node2D

# Used by the throwable to access the shooter variable of the hitbox
@onready var enemy_hitbox_component = $HitBoxComponent
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $AnimatedSprite2D2

@export_enum("impact", "explosion", "lightning") var hit_box_type  # helps the gore system choose vfxs

var animation: String

func initialize(args):
	var animation_index = args.pick_random()
	animation = animations[animation_index]

func _ready():
	animated_sprite.play(animation)
	animation_player.play("explode")


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
	enemy_hitbox_component.shooter = player

