extends RigidBody2D

"""
Free time should be longer than the spawn animation, which is one second.
"""

@export var free_time: float
@onready var timer: Timer = $Timer
@onready var animation_player = $AnimationPlayer

@export_enum("upwards", "downwards", "splatter") var spawn_animation


func _ready():
	if spawn_animation == 0:
		animation_player.play("spawn_upwards")
	elif spawn_animation == 1:
		animation_player.play("spawn_downwards")
	elif spawn_animation == 2:
		animation_player.play("splatter")
	
	timer.start(free_time)


func _on_timer_timeout():
	animation_player.play("fade_out")
	
func _on_fade_out_end():
	queue_free()
