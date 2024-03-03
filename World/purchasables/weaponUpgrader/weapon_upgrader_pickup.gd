extends "res://World/purchasables/purchasable.gd"

"""
The mystery box spawns this in and sets the weapon name so the player can pick it up.
The pack a punch also uses this in a similar way but sets the weapon level
"""

@onready var bullet_types = ['fiery', 'frosty', 'explosive']

@onready var bullet_modifier_map = {
	'fiery': preload("res://World/purchasables/Weapons/components/Bullets/BulletExplosive.tscn"),
	'frosty': preload("res://World/purchasables/Weapons/components/Bullets/BulletFrost.tscn"),
	'explosive': preload("res://World/purchasables/Weapons/components/Bullets/Bullet_Fire.tscn")
}

var weapon_name: String  # Set by mystery box
# firstUpgrade=1, secondUpgrade=2
var weapon_level: int = 0  # set by pack a punch

signal mystery_box_weapon_picked_up


func _ready():
	purchasable_name = 'Pickup ' + weapon_name

func give_item(player: CharacterBody2D):
	assert(weapon_name != '', "You didn't set the name for the weapon upgrader pickup")
	assert(weapon_level > 0, "You didnt set the weapon level, cant upgrade to level 0!")
	assert(Globals.GUN_INDEX.keys().find(weapon_name) != -1, "You are creating a weapon name that isnt in the global GUN_INDEX list.")
	
	# Create the weapon
	var weapon_object = Globals.GUN_INDEX[weapon_name].scene.instantiate()
	
	# Check if player already has this weapon and remove it 
	# (cause they put the gun in the upgrader, then bought it, and then picked it up from the upgrader)
	if player.weapon_manager.has_gun(weapon_name):
		player.weapon_manager.remove_gun(weapon_name)

	# Give the player the weapon
	player.weapon_manager.add_weapon_object(weapon_object)
	Events.emit_signal("player_log", "Picked up " + purchasable_name)
	
	# Set the guns level
	weapon_object.set_gun_level(weapon_level)
	
	# Sets the gun's bullet
	if weapon_level == 2:
		var bullet_type = bullet_types.pick_random()
		weapon_object.set_bullet(bullet_modifier_map[bullet_type], bullet_type)
	
	# Let the mystery box know the weapons been picked up
	emit_signal("mystery_box_weapon_picked_up")
	
	# Deletes itself
	queue_free()
