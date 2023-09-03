extends "res://World/purchasables/purchasable.gd"

"""
Similar to the weapon buy, the perk buy checks if the player already has the perk,
if they dont, simply passes the string of the perk to the player, and the logic
happens in the player.
"""

@export var perk_name: String
@onready var audio: AudioStreamPlayer2D = $Audio
var is_power_on: bool = false

func _ready():
	can_be_purchased = true  # This has to be true or the player wont see the interactable message
	Events.power_activated.connect(_on_power_on)

func _on_power_on():
	can_be_purchased = true
	is_power_on = true

func purchase_item(player: CharacterBody2D) -> void:
	"""
	Overriding the parent method since we want the player to see the purchasable message (must be purchasble)
	but dont want the player buying it unless the power is on.
	"""
	
	if !is_power_on:
		Events.emit_signal("player_log", "Must Turn On Power !")
		return

	if player.money_component.money < purchasable_cost:
		Events.emit_signal("player_log", "Not enough money")
		return
	give_item(player)

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

func get_interactable_message(player: CharacterBody2D) -> String:
	if !is_power_on:
		return "Must turn on the power!"
	
	# Check if player already has the perk
	if !player.perk_manager.perks.find(perk_name) == -1:
		return "Already have " + str(purchasable_name)
	else:
		return "Buy " + purchasable_name + ": " + str(purchasable_cost)
