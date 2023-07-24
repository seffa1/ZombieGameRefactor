extends Node

"""
Weapons the player gets are attached as a child to this node.
This script handles all things weapons:
	equiping, reloading, shooting, informing the UI, weapon modifiers

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

# Nodes

# Constants

# Variables
@onready var weapons: Array = []
@onready var modifiers: Array = []
@onready var max_weapon_count: int = 2

func add_weapons(weapon_name: String):
	# TODO
	return

func add_modifier(modifier_name: String):
	# TODO
	return

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
