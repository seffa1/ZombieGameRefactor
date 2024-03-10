extends "res://World/purchasables/purchasable.gd"

var vessel_charge_count: int = 0

func _ready():
	Events.vessel_charged.connect(_on_vessel_charged)
	can_be_purchased = false

func _on_vessel_charged():
	vessel_charge_count += 1
	if vessel_charge_count == 3:
		can_be_purchased = true

func purchase_item(player: CharacterBody2D) -> void:
	if !can_be_purchased:
		Events.emit_signal("player_log", "Requires 3 powered vessel modules. Only " + str(Globals.vessels_charged) + " charging sequences complete.")

	give_item(player)
	
func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	Events.emit_signal("player_log", "Keycard Aquired")
	$"../AnimationPlayer".play("powered")


func get_interactable_message(player: CharacterBody2D) -> String:
	if can_be_purchased:
		return "Pickup Keycard"
	else:
		return ""
