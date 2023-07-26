extends Node2D

"""
Weapons the player gets are attached as a child to this node.
This script handles all things weapons:
	equipping, reloading, shooting, informing the UI, weapon modifiers, updating the player's animation tree

Any number/combinations of weapons can go into the weapons array
and the UI will programatically update. But the max number of weapons that
can be in the array is governed by max_weapons_count. This will be able to
be increased by a perk ( think mule kick ).

Any number/combination of modifiers (double tap, instakill, pack-a-punch) are tracked in an array
and are passed to the gun each time it shoots.

Weapons are instantiated in this script as well. Weapon buys simply pass us the
name of the weapon and this class handles the rest.

The shoot signal flow: 
	1. stateMachineAction (shoot state) -> plays animation and signals to the weapons container to shoot
	2. WeaponContainer -> check if we have a gun and it has ammo
	3. WeaponContainer -> check if there are any modifiers to add to the gun (from perks, powerups)
	4. WeaponContainer -> tell the gun to shoot, passing in an array of modifiers
	5. Gun -> add modifiers to the gun, then create the bullet(s)
	6. Gun -> check if any modifiers need to modifiy the bullet and add them (instakill)
	7. Gun -> give bullet position / direction and add to world
	8. Bullet (now in the world) -> collide with enemy/tile/nothing 
		and signal information back to the player (to gain money, etc)
"""

# Signals
signal player_weapons_change(weapon_names: Array[String])
signal player_equipped_change(weapon_name: String)

# Reference to all weapons
@onready var dev_canon = preload("res://World/purchasables/Weapons/DevCanon/DevCanon.tscn")

# Variables
var weapon_names: Array[String] = []  # This may get deleted since its redundant
var weapon_objects: Array[Node2D] = []
var current_weapon_index: int
var max_weapon_count: int = 2

var modifiers: Array[String] = []

func add_weapon(weapon_name: String):
	assert(Globals.GUN_INDEX.keys().find(weapon_name) != -1, "You are adding a weapon name that isnt in the global GUN_INDEX.: " + str(weapon_name))
	
	# The weapon buys check if we already have the same weapon before it gives it to the player.
	# So we should never have two of the same gun.
	assert(weapon_names.find(weapon_name) == -1, "The player got a weapon name they already had listed.")
	
	# Create the weapon
	weapon_names.append(weapon_name)
	_create_weapon(weapon_name)
	
	# Set it as equipped
	var weapon_index = weapon_names.find(weapon_name)
	_set_equipped_gun(weapon_index)
	
	# Info the HUD
	emit_signal("player_weapons_change", weapon_names)

func _set_equipped_gun(weapon_index: int):
	"""
	Changes the player's animation tree to the weapon-specific animation tree. The StateMachineAction
	will call for the same animation name, no matter the animation tree.
	"""
	assert(weapon_index != -1, "You tried to set a weapon that you don't have.")
	current_weapon_index = weapon_index
	# TODO - update the player's animation tree
	
	# Inform the UI
	emit_signal("player_equipped_change", weapon_names[current_weapon_index])

func _create_weapon(weapon_name: String):
	"""
	Instantiates a weapons and adds it as a child. 
	Store a reference in the weapon_objects array.
	"""
	# Create the correct weapon
	var weapon_object
	match weapon_name:
		"DEV_CANON":
			weapon_object = dev_canon.instantiate()
	assert(weapon_object != null, "trying to create a weapon that isnt in the match statement.")

	# Add it to the tree and store a reference
	add_child(weapon_object)
	weapon_objects.append(weapon_object)

func has_a_gun() -> bool:
	return len(weapon_objects) > 0
	
func get_equipped_gun():
	assert(has_a_gun(), "You tried to get equipped a gun when you dont have any.")
	return weapon_objects[current_weapon_index]


