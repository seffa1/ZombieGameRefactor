extends "res://World/purchasables/purchasable.gd"

var vessel_charge_count: int = 0

func _ready():
	Events.vessel_charge_complete.connect(_on_vessel_charged)
	can_be_purchased = true
	$"../AnimationPlayer".play("idle")

func _on_vessel_charged():
	vessel_charge_count += 1
	if vessel_charge_count == 3:
		$"../AnimationPlayer".play("powered")

func purchase_item(player: CharacterBody2D) -> void:
	if vessel_charge_count < 3:
		Events.emit_signal("player_log", str(vessel_charge_count) + "/3 charging sequences complete.")
		return

	give_item(player)
	
func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	Events.emit_signal("player_log", "Keycard Aquired")
	$"../keycard".hide()
	can_be_purchased = false
	Events.emit_signal("has_keycard")
	Globals.has_keycard = true
	

func get_interactable_message(player: CharacterBody2D) -> String:
	if vessel_charge_count < 3:
		return "Requires 3 powered vessel modules. Only " + str(vessel_charge_count) + " charging sequences complete."
	else:
		return "Pickup Keycard"
