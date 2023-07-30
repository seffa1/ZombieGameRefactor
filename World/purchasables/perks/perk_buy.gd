extends "res://World/purchasables/purchasable.gd"

"""
Similar to the weapon buy, the perk buy checks if the player already has the perk,
if they dont, simply passes the string of the perk to the player, and the logic
happens in the player.
"""

@export var perk_name: String
@onready var audio: AudioStreamPlayer2D = $Audio

func give_item(player: CharacterBody2D):
	"""
	Checks if the player can get the perk.
	"""
	assert(Globals.PERK_INDEX.keys().find(perk_name) != -1, "Perk name doesnt match global index")
	
	# Check if they already have the perk
	if !player.perk_manager.perks.find(perk_name) == -1:
		Events.emit_signal("player_log", "Already have " + purchasable_name)
		return
	else:
		# Take the money and give the perk
		player.money_component.money -= purchasable_cost
		player.perk_manager.add_perk(perk_name)
		audio.play()
		Events.emit_signal("player_log", "Purchased " + purchasable_name)

func get_interactable_message() -> String:
	if can_be_purchased:
		return "Buy " + purchasable_name + ": " + str(purchasable_cost)
	else:
		return "Must turn on the power!"
