extends Node2D

func play():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("charge")


