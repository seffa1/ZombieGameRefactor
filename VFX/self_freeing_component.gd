extends RigidBody2D

"""
Free time should be longer than the spawn animation, which is one second.
"""

@export var free_time: float
@onready var timer: Timer = $Timer
@onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.play("spawn")
	timer.start(free_time)


func _on_timer_timeout():
	animation_player.play("fade_out")
	
func _on_fade_out_end():
	queue_free()
