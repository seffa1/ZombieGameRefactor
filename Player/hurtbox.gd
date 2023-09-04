extends Area2D

@onready var health_component = $"../HealthComponent"
@export var hit_timer_interval: float

func _on_area_entered(_area: Area2D):
	if owner.hit_timer.is_stopped():
		owner.hit_timer.start(hit_timer_interval)
		print("Player takes hit")
		# Damage per zombit hit, 
		# TODO - if we have different zombie types that do different damage, well have to change how this works
		health_component.health -= 10.0  
		
		if health_component.health <= 0:
			print("Player dies")
