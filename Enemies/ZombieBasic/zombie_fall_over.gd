extends Node2D

func _ready():
	if randi_range(0, 1) == 0:
		$AnimationPlayer.play("fallOver_1")
	else:
		$AnimationPlayer.play("fallOver_2")
