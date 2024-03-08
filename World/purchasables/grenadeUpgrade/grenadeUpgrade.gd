extends "res://World/purchasables/purchasable.gd"

func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	player.money_component.money -= purchasable_cost
	Events.emit_signal("player_log", "Purchased " + purchasable_name)
	player.equipment_manager.current_equipment = 'CLUSTER_BOMB'
	player.equipment_manager.refill_equipment()
	$"../Audio".play()
	return
