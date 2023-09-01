extends "res://World/purchasables/purchasable.gd"

@onready var animation_player = $AnimationPlayer

func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	player.money_component.money -= purchasable_cost
	Events.emit_signal("player_log", "Power activated")
	Globals.is_power_on = true
	can_be_purchased = false
	animation_player.play("switch_on")
	return

func get_interactable_message() -> String:
	if can_be_purchased:
		return "Activate power"
	else:
		return ""
