extends Area2D

@onready var health_component = $"../HealthComponent"
@onready var hurt_sounds = $"../HurtSounds"
@onready var hit_sounds = $"../HitSounds"
@export var hit_timer_interval: float


func _process(delta):
	if has_overlapping_areas():
		var areas = get_overlapping_areas()
		for area in areas:
			# The name of the hitbox component from Explosion.tscn
			if area.name == 'PlayerHitbox_Explosion':
				health_component.health -= 100.0 
		
		if owner.hit_timer.is_stopped():
			owner.hit_timer.start(hit_timer_interval)

			# Damage per zombit hit, 
			# TODO - if we have different zombie types that do different damage, well have to change how this works
			health_component.health -= 10.0 
			hurt_sounds.play_random()
			hit_sounds.play_random()

			if health_component.health <= 0:
				Events.emit_signal("player_dies")

