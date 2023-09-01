extends "res://World/purchasables/purchasable.gd"

"""
Generic Weapon buy used by all weapons. To use, inherit from this class,
enter a valid weapon_name, cost, and Purchaseable Name. See Globals.GUN_INDEX for 
a list of valid gun names.

Make the sub-resources unique and adjust the interactionZone size to fit the weapon.
Add a sprite for the weapon.
"""


@onready var audio: AudioStreamPlayer2D = $Audio

@export var weapon_name: String
@export var weapon_cost: int = 1000
@export var ammo_cost_level_1: int = 500
@export var ammo_cost_level_2: int = 4500  # pack-a-punched weapons


var can_buy_weapon: bool = true  # If false, they'll be able to be ammo

func _ready():
	# Weapon buy purchasble is updated in process
	assert(purchasable_name == '', "Weapon buy purchasble names should start empty.")

func _process(delta):
	# Only process if the player is in range to buy
	if !has_overlapping_bodies():
		purchasable_name = ''
		return

	assert(len(get_overlapping_bodies()) == 1, "Why are two things overlapping the purchasable?")
	var player = get_overlapping_bodies()[0]

	# Check if player already has this gun
	if player.weapon_manager.has_gun(weapon_name):

		# If they do, then setup to sell ammo
		can_buy_weapon = false
		purchasable_name = Globals.GUN_INDEX[weapon_name].nice_name + " ammo"
		if player.weapon_manager.get_gun(weapon_name).weapon_level == 0:
			purchasable_cost = ammo_cost_level_1
		else:
			purchasable_cost = ammo_cost_level_2
	else:

		# If they dont, then setup to sell the gun
		can_buy_weapon = true
		purchasable_name = Globals.GUN_INDEX[weapon_name].nice_name
		purchasable_cost = weapon_cost

func give_item(player: CharacterBody2D):
	"""
	Function which must be defined by all children classes.
	"""
	assert(Globals.GUN_INDEX.keys().find(weapon_name) != -1, "Weapon name doesnt match global index " + str(weapon_name))
	
	# If selling a weapon
	if can_buy_weapon:
		# Check if player already has this gun
		if player.weapon_manager.has_gun(weapon_name):
			Events.emit_signal("player_log", "Already have " + purchasable_name)
			return
		
		# If they dont, make the transaction and pass the gun name along
		player.money_component.money -= purchasable_cost
		audio.play()
		player.weapon_manager.add_weapon(weapon_name)
		Events.emit_signal("player_log", "Purchased " + purchasable_name)
	
	# If selling ammo
	elif !can_buy_weapon:
		# Check if player DOESNT have this gun
		if player.weapon_manager.weapon_names.find(weapon_name) == -1:
			Events.emit_signal("player_log", "Dont have " + weapon_name)
			return
		else:
			# If do, make sure the ammo isnt full
			var weapon_object = player.weapon_manager.get_gun(weapon_name)
			if weapon_object.is_ammo_full():
				Events.emit_signal("player_log", "Ammo full for " + weapon_name)
				return
			
			# make the transaction and pass the gun name along
			audio.play()
			player.money_component.money -= purchasable_cost
			
			player.weapon_manager.refill_weapon_ammo(weapon_object)
			Events.emit_signal("player_log", "Purchased " + purchasable_name)

