extends "res://World/purchasables/purchasable.gd"

"""
Generic Weapon buy used by all weapons. To use, inherit from this class,
enter a valid weapon_name, cost, and Purchaseable Name. See Globals.GUN_NAMES for 
a list of valid gun names.

Make the sub-resources unique and adjust the interactionZone size to fit the weapon.
Add a sprite for the weapon.
"""

@export var weapon_name: String

func give_item(player: CharacterBody2D):
	"""
	Function which must be defined by all children classes.
	"""
	# Check if player already has this gun
	if !player.weapon_container.weapons.find(weapon_name) == -1:
		Events.emit_signal("player_log", "Already have " + purchasable_name)
		return
	
	# If they dont, make the transaction and pass the gun name along
	player.money -= purchasable_cost

	player.weapon_container.add_weapon(weapon_name)
	Events.emit_signal("player_log", "Purchased " + purchasable_name)

