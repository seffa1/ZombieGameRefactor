extends "res://World/purchasables/purchasable.gd"


func give_item(player: CharacterBody2D):
	"""
	Checks if the player can get stamina.
	"""
	# Check if they already have the perk
	if !player.perks.find(purchasable_name) == -1:
		Events.emit_signal("player_log", "Already have " + purchasable_name)
		return
		
	# Take the money, give the perk, and track the perk
	player.money -= purchasable_cost
	player.max_stamina = 200
	player.perks.append(purchasable_name)
	
	Events.emit_signal("player_log", "Purchased " + purchasable_name)

