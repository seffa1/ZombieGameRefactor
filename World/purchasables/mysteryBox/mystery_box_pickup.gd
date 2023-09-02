extends "res://World/purchasables/purchasable.gd"

"""
The mystery box spawns this in and sets the weapon name so the player can pick it up.
"""

var weapon_name: String  # Set by mystery box

signal mystery_box_weapon_picked_up

func _ready():
	purchasable_name = 'Pickup ' + weapon_name

func give_item(player: CharacterBody2D):
	assert(weapon_name != '', "You didn't set the name for the mystery box pickup")

	player.weapon_manager.add_weapon(weapon_name)
	Events.emit_signal("player_log", "Picked up " + purchasable_name)
	
	# Let the mystery box know the weapons been picked up
	emit_signal("mystery_box_weapon_picked_up")
	queue_free()
