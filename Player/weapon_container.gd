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
	2. weapon_manager -> check if we have a gun and it has ammo
	3. weapon_manager -> check if there are any modifiers to add to the gun (from perks, powerups)
	4. weapon_manager -> tell the gun to shoot, passing in an array of modifiers
	5. Gun -> add modifiers to the gun, then create the bullet(s)
	6. Gun -> check if any modifiers need to modifiy the bullet and add them (instakill)
	7. Gun -> give bullet position / direction and add to world
	8. Bullet (now in the world) -> collide with enemy/tile/nothing 
		and signal information back to the player (to gain money, etc)
"""

# Nodes
@onready var gun_sprite = $"../SkeletonControl/HandPosition/GunSprite"
@onready var buy_weapon_state: Node = $"../StateMachineAction/BuyWeapon"

# the names and objects array should always be in the same order
# the names array just makes looking up weapons easier so we dont have to try
# and figure out what gun's the objects are. The weapon index sets
# the player's current gun, and is used in both arrays to lookup the gun name
# and weapon object when needed
var weapon_names: Array[String] = []  #
var weapon_objects: Array[Node2D] = []
var current_weapon_index: int
var max_weapon_count: int = 2

# Set by perk manager. Used for perk bonus' (double tab, speed cola, instakill, etc.)
# This array is passed to a gun when its equipped OR when a new modified is added, and cleared from that gun if its unequipped
var modifiers: Array[String] = []  

func add_modifier(modifier: String):
	# TODO - this might break if we use this system for power up drops (instakill)
	assert(!modifier.find(modifier) == -1, "You are adding a modifier that you already have!")
	modifiers.append(modifier)
	if has_a_gun():
		get_equipped_gun().set_modifiers(modifiers)

func add_weapon(weapon_name: String):
	"""
	Called by the weapon buy on the purchase of a weapon.
	"""
	print('Added weapon')
	print(weapon_name)
	assert(Globals.GUN_INDEX.keys().find(weapon_name) != -1, "You are adding a weapon name that isnt in the global GUN_INDEX list.")
	
	# The weapon buys check if we already have the same weapon before it gives it to the player.
	# So we should never have two of the same gun.
	assert(weapon_names.find(weapon_name) == -1, "The player got a weapon name they already had listed.")

	# Create the weapon and store the name
	_create_weapon(weapon_name)
	weapon_names.append(weapon_name)
	
	# Store the previous gun name in the buy_weapon state for animation purposes
	buy_weapon_state.switch_from_gun_name = get_equipped_gun_name()
	
	# Check if we have the max guns already
	if number_of_guns() > max_weapon_count:
		# Then remove the currently equipped gun before equipping the new one
		var gun_to_remove = weapon_objects[current_weapon_index]
		weapon_names.remove_at(current_weapon_index)
		weapon_objects.remove_at(current_weapon_index)
		remove_child(gun_to_remove)
	
	# Set it as equipped
	var new_current_weapon_index = weapon_names.find(weapon_name)
	_set_equipped_gun(new_current_weapon_index)
	
	# Store the new gun name in the buy_weapon state for animation purposes
	buy_weapon_state.switch_to_gun_name = weapon_name
	
	Events.emit_signal("player_buy_weapon")

	# Info the HUD
	Events.emit_signal("player_weapons_change", weapon_names)

func add_weapon_object(weapon_object):
	"""
	Used by the pack a punch machine which needs to create and modify the weapon
	object BEFORE passing it to the player.
	"""
	var weapon_name = weapon_object.WEAPON_NAME
	
	# Add it to the tree and store a reference
	add_child(weapon_object)
	weapon_objects.append(weapon_object)
	weapon_names.append(weapon_name)
	
	# Store the previous gun name in the buy_weapon state for animation purposes
	buy_weapon_state.switch_from_gun_name = get_equipped_gun_name()
	
	# Check if we have the max guns already
	if number_of_guns() > max_weapon_count:
		# Then remove the currently equipped gun before equipping the new one
		weapon_names.remove_at(current_weapon_index)
		weapon_objects.remove_at(current_weapon_index)
		
	# Set it as equipped
	var new_current_weapon_index = weapon_names.find(weapon_name)
	_set_equipped_gun(new_current_weapon_index)
	
	# Store the new gun name in the buy_weapon state for animation purposes
	buy_weapon_state.switch_to_gun_name = weapon_name
	
	Events.emit_signal("player_buy_weapon")

	# Info the HUD
	Events.emit_signal("player_weapons_change", weapon_names)
	Events.emit_signal("player_equipped_change", weapon_object.get_nice_name(), weapon_object.weapon_level, weapon_object.get_modifier())

func put_gun_in_upgraded():
	"""
	Called by weapon upgraded
	"""
	# Remove the current gun
	var current_gun = weapon_objects[current_weapon_index]
	weapon_names.remove_at(current_weapon_index)
	weapon_objects.remove_at(current_weapon_index)
	remove_child(current_gun)
	current_weapon_index = 0
	
	# If we have another gun, switch to it
	if has_a_gun():
		Events.emit_signal("player_switch_weapons")
	
	# If we DONT have anyother gun, call the idle state again which will switch to an 'idle_noWeapon' animation
	else:
		Events.emit_signal("player_action_idle")
	
	# Inform HUD
	Events.emit_signal("player_weapons_change", weapon_names)


func _set_equipped_gun(weapon_index: int):
	"""
	Updates the current weapon index which determines which gun name / gun object is 
	retrieved from the weapon names and weapon object arrays from the other methods.
	"""
	
	# disable any components from the gun we are un-equipping
	if has_a_gun():
		get_equipped_gun().toggle_crosshairs(false)
		get_equipped_gun().toggle_raycast(false)
		get_equipped_gun().clear_modifiers()

	assert(weapon_index != -1, "You tried to set a weapon that you don't have.")
	current_weapon_index = weapon_index
	
	# Enable any components from the gun we are equipping
	get_equipped_gun().toggle_crosshairs(true)
	get_equipped_gun().toggle_raycast(true)
	get_equipped_gun().set_modifiers(modifiers)

	# Inform the UI
	Events.emit_signal("player_equipped_change", get_equipped_gun().get_nice_name(), get_equipped_gun().weapon_level, get_equipped_gun().get_modifier())
	Events.emit_signal("player_equipped_clip_count_change", get_equipped_gun().bullets_in_clip)
	Events.emit_signal("player_equipped_reserve_count_change", get_equipped_gun().bullet_reserve)

func _create_weapon(weapon_name: String):
	"""
	Instantiates a weapons and adds it as a child. 
	Store a reference in the weapon_objects array.
	"""
	assert(Globals.GUN_INDEX.keys().find(weapon_name) != -1, "You are creating a weapon name that isnt in the global GUN_INDEX list.")
	
	# Create the correct weapon
	var weapon_object = Globals.GUN_INDEX[weapon_name].scene.instantiate()

	# Add it to the tree and store a reference
	add_child(weapon_object)
	print('crewating weapon')
	print(weapon_object)
	weapon_objects.append(weapon_object)

func has_a_gun() -> bool:
	return len(weapon_objects) > 0

func has_two_guns() -> bool:
	return len(weapon_objects) > 1

func has_gun(weapon_name: String) -> bool:
	return weapon_names.find(weapon_name) != -1

func remove_gun(weapon_name: String):
	"""
	Called by weaponUpgrader pickup if we happen to have a the same gun 
	that we are already picking up. Should only happen if we put a gun in the upgrader,
	then buy it before picking it up again.
	"""
	var index = weapon_names.find(weapon_name)
	if index == -1:
		return
	var gun_to_remove = weapon_objects[index]
	weapon_names.remove_at(index)
	weapon_objects.remove_at(index)
	remove_child(gun_to_remove)
	current_weapon_index = 0
	
	# If we have another gun, switch to it
	if has_a_gun():
		Events.emit_signal("player_switch_weapons")
	
	# If we DONT have anyother gun, call the idle state again which will switch to an 'idle_noWeapon' animation
	else:
		Events.emit_signal("player_action_idle")
	

func number_of_guns():
	return len(weapon_names)

func get_equipped_gun():
	assert(has_a_gun(), "You tried to get equipped a gun when you dont have any.")
	print('Getting gun')
	print(weapon_objects)
	print(current_weapon_index)
	return weapon_objects[current_weapon_index]

func get_equipped_gun_name():
	assert(has_a_gun(), "You tried to get equipped a gun when you dont have any: " + str(weapon_names))
	return weapon_names[current_weapon_index]
	
func get_gun(weapon_name: String):
	"""
	Used by the ammo buys to refill a weapon, even if its not equipped
	"""
	for weapon in weapon_objects:
		if weapon.WEAPON_NAME == weapon_name:
			return weapon
	assert(false, "Trying to get gun but dont have one: " + weapon_name)

func max_ammo():
	"""
	Called by the max ammo pickup effect.
	"""
	for weapon in weapon_objects:
		refill_weapon_ammo(weapon)

func refill_weapon_ammo(weapon: Node2D):
	"""
	If a player already has a weapon from a weapon buy, the weapon buy instead 
	sells ammo for that gun. The weapon buy calls this function during that process.
	Called by the max_ammo() function for each weapon as well.
	"""
	weapon.refill_ammo()

func next_weapon():
	"""Called by player action state machine idle."""
	if len(weapon_names) == 0:
			return
	var newIndex = current_weapon_index + 1
	if newIndex > len(weapon_names) - 1:
		newIndex = 0
	_set_equipped_gun(newIndex)
	
func previous_weapon():
	"""Called by player action state machine idle."""
	if len(weapon_names) == 0:
			return
	var newIndex = current_weapon_index - 1
	if newIndex < 0:
		newIndex = len(weapon_names) - 1
	_set_equipped_gun(newIndex)
