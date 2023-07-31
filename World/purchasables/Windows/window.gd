extends "res://World/purchasables/purchasable.gd"

@export var window_repair_money_reward: int = 10
@onready var health_component: Node2D = $HealthComponent

func give_item(player: CharacterBody2D) -> void:
	"""
	Repair the window.
	"""
	Events.emit_signal("player_log", "Repaired " + purchasable_name)
	Events.emit_signal("give_player_money", window_repair_money_reward)
	
	health_component.health += 1  # Window gets 1 health for each repair
	return

func get_interactable_message() -> String:
	if can_be_purchased:
		return "Repair " + purchasable_name
	else:
		return ""
