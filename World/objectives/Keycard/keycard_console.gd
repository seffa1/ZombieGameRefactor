extends "res://World/purchasables/purchasable.gd"

@export var vessel_count: int = 3

var vessel_charge_count: int = 0

func _ready():
	Events.vessel_charge_complete.connect(_on_vessel_charged)
	can_be_purchased = true
	$"../AnimationPlayer".play("idle")
	$"../LightFlicker".hide()

func _on_vessel_charged():
	vessel_charge_count += 1
	if vessel_charge_count == vessel_count:
		$"../AnimationPlayer".play("powered")
		$"../LightFlicker".show()

func purchase_item(player: CharacterBody2D) -> void:
	if vessel_charge_count < vessel_count:
		Events.emit_signal("player_log", str(vessel_charge_count) + "/" + str(vessel_count) + " charging sequences complete.")
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
	if vessel_charge_count < vessel_count:
		return "Requires " + str(vessel_count) + "powered vessel modules. Only " + str(vessel_charge_count) + " charging sequences complete."
	else:
		return "Pickup Keycard"
