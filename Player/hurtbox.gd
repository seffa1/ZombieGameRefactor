extends Area2D

@export var hit_timer_interval: float

func _on_area_entered(area: Area2D):
	print("Player takes hit")
	if owner.hit_timer.is_stopped():
		owner.hit_timer.start(hit_timer_interval)
		print("Player takes hit")
