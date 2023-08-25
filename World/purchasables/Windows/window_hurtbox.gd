extends Area2D


@export var health_component: Node2D
@export var damage_timer: Timer
@export var damage_interval: float

@onready var window_break_sounds: AudioStreamPlayer2D = $"../WindowBreakSounds"

func _on_area_entered(_area: Area2D):
	"""
	The area here is the enemy's hitbox.
	"""
	
	if damage_timer.is_stopped():
		damage_timer.start(damage_interval)
		health_component.health -= 1  # window takes 1 damage for each zombie hit
				
		owner.update_animation_frame(health_component.health)
		
		

