extends Area2D

signal is_electrocuted

func _on_area_entered(area: Area2D):
	"""
	The area here should be the HitBoxComponent-Lighting
		area.damage
	"""
	print("Lightning Hit!")
	print(area.damage)

func electrocute(damage_per_second: float, electrocution_time: float):
	"""
	Called on by the lighting.
	"""
	print('ELECTROCUTE')
	print(damage_per_second)
	print(electrocution_time)
