extends "res://World/purchasables/purchasable.gd"


func give_item(player: PackedScene):
	"""
	Function which must be defined by all children classes.
	"""
	player.stamina = 200
