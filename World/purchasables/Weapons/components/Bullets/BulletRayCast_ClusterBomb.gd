extends RayCast2D

@onready var grenade_spawner: Node2D = %GrenadeSpawner

func shoot():
	var mouse_vector = get_global_mouse_position() - global_position
	var mouse_distance = mouse_vector.length()
	
	# Set Speed
	var speed = clampf(mouse_distance, 0, 600.0)
	grenade_spawner.item_ejection_speed = speed

	# Set rotation
	var rotation = mouse_vector.angle() - deg_to_rad(90)
	grenade_spawner.spawn_item(rotation)
