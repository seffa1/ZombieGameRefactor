extends Area2D

"""
Base class used by all weapons/equipment/perks/traps/etc. that can be purchased by the player.
"""

@export var purchasable_cost: int = 0
@export var purchasable_name: String = ""  # Used by the interactable log
@export var can_be_purchased: bool = true 

func purchase_item(player: CharacterBody2D) -> void:
	"""
	This function is called by the player when they try to purchase an item.
	It checks if they have the money to buy it ( shared by all purchasables. )
	
	If they are able to purchase the item, then a "give_item" function is called
	with a reference to the player. This function must be defined for all purchasbles
	and will give the player the item (weapons/esawquipment/perk) or open a door / activate a trap
	etc. 
	
	This class is also used for things the player interacts with but doesnt buy, like 
	a power switch. We treat it behind-the-scenes as 'purchasing something for $0'.
	"""
	
	if !can_be_purchased:
		return

	if player.money < purchasable_cost:
		Events.emit_signal("player_log", "Not enough money")
		return
	give_item(player)
	
func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	player.money -= purchasable_cost
	Events.emit_signal("player_log", "Purchased " + purchasable_name)
	return

func get_interactable_message() -> String:
	if can_be_purchased:
		return "Buy " + purchasable_name + ": " + str(purchasable_cost)
	else:
		return ""

