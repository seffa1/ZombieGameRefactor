extends "res://World/purchasables/purchasable.gd"

"""
Generic Weapon buy used by all weapons. To use, inherit from this class,
enter a valid weapon_name, cost, and Purchaseable Name. See Globals.GUN_INDEX for 
a list of valid gun names.

Make the sub-resources unique and adjust the interactionZone size to fit the weapon.
Add a sprite for the weapon.
"""

@export var weapon_name: String
@onready var audio: AudioStreamPlayer2D = $Audio

func give_item(player: CharacterBody2D):
	"""
	Function which must be defined by all children classes.
	"""
	assert(Globals.GUN_INDEX.keys().find(weapon_name) != -1, "Weapon name doesnt match global index " + str(weapon_name))
	
	# Check if player already has this gun
	if player.weapon_manager.has_gun(weapon_name):
		Events.emit_signal("player_log", "Already have " + purchasable_name)
		return
	
	# If they dont, make the transaction and pass the gun name along
	player.money_component.money -= purchasable_cost
	audio.play()
	player.weapon_manager.add_weapon(weapon_name)
	Events.emit_signal("player_log", "Purchased " + purchasable_name)

func _update_can_be_purchased(body: CharacterBody2D) -> void:
	"""
	When the player enters or exits the buy zone, we need to check 
	if they already have this weapon, if so, make it non-purchasable.
	Called by the area2D signals below.
	"""
	# Check if player already has this gun
	if body.weapon_manager.has_gun(weapon_name):
		can_be_purchased = false
	else:
		can_be_purchased = true

func _on_body_entered(body: CharacterBody2D):
	_update_can_be_purchased(body)

func _on_body_exited(body: CharacterBody2D):
	_update_can_be_purchased(body)
