extends RigidBody2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export_enum("upwards", "downwards", "splatter") var spawn_animation


func _ready():
	if spawn_animation == 0:
		animation_player.play("spawn_upwards")
	elif spawn_animation == 1:
		animation_player.play("spawn_downwards")
	elif spawn_animation == 2:
		animation_player.play("splatter")
	
	collision_shape.get_shape().disabled = true



func _on_animation_finsished():
	collision_shape.get_shape().disabled = false
