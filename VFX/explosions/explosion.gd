extends Node2D

# Used by the throwable to access the shooter variable of the hitbox
@onready var enemy_hitbox_component = $HitBoxComponent
@onready var player_hitbox_component = $PlayerHitbox
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $AnimatedSprite2D2

@onready var damage_player: bool
@onready var damage_enemy: bool

var animation: String

func init(damage_enemy, damage_player, args):
	damage_enemy = damage_enemy
	damage_player = damage_player
	var animation_index = args.pick_random()
	animation = animations[animation_index]

func _ready():
	if damage_player:
		player_hitbox_component.monitorable = true
		player_hitbox_component.monitoring = true
	if damage_enemy:
		enemy_hitbox_component.monitorable = true
		enemy_hitbox_component.monitoring = true
	
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

