extends Area2D


func _on_area_entered(area: Area2D):
	"""
	The area here should be the HitBoxComponent-Lighting
		area.damage
	"""
	print("Lightning Hit!")
	print(area.damage)
