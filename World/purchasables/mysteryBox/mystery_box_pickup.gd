extends "res://World/purchasables/Weapons/weapon_buy.gd"

"""
The mystery box created this weapon buy, sets the exports manually, then when the player
pickups up the gun, give the player the gun and then queue_free.
Player should never get a mystery box spin for a weapon they already have.
"""

signal mystery_box_weapon_picked_up

func give_item(player: CharacterBody2D):
	assert(weapon_name != '', "You didn't set the name for the mystery box pickup")
	assert(purchasable_cost == 0, "Mystery box pickup shouldnt cost money")
	assert(purchasable_name != '', "You didnt set the purchase message for the mystery box.")
	
	player.money_component.money -= purchasable_cost
	player.weapon_manager.add_weapon(weapon_name)
	Events.emit_signal("player_log", "Picked up " + purchasable_name)
	
	# Let the mystery box know the weapons been picked up
	emit_signal("mystery_box_weapon_picked_up")
	queue_free()
