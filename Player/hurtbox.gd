extends Area2D

@onready var health_component = $"../HealthComponent"
@export var hit_timer_interval: float

func _on_area_entered(_area: Area2D):
	if owner.hit_timer.is_stopped():
		owner.hit_timer.start(hit_timer_interval)
		print("Player takes hit")
		health_component.health -= 1
		
		if health_component.health <= 0:
			print("Player dies")
