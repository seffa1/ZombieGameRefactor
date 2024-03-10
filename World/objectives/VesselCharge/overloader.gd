extends "res://World/purchasables/purchasable.gd"

signal overload_activated

func _ready():
	$"..".charging_complete.connect(_on_chargin_complete)

func _on_chargin_complete():
	can_be_purchased = true

func purchase_item(player: CharacterBody2D) -> void:
	if !can_be_purchased:
		return

	if !Globals.has_keycard:
		Events.emit_signal("player_log", "Keycard required for overload sequence.")
		return
	give_item(player)
	
func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	Events.emit_signal("player_log", "Overload sequence activated")
	emit_signal("overload_activated")
	can_be_purchased = false

func get_interactable_message(player: CharacterBody2D) -> String:
	if can_be_purchased:
		if Globals.has_keycard:
			return "Overload Essense Vessel"
		else:
			return "Key required for overload sequence"
	else:
		return ""
