extends "res://World/purchasables/purchasable.gd"

@onready var gun_switching_timer: Timer = $gunSwitchingTimer
@onready var gun_sprite: Sprite2D = $GunSelectionSprite

@export var number_of_switches: int = 6  # how many guns does the box cycle through before giving you one ?


var is_selecting: bool = false  # Is the mystery currently seleting a weapon to give the player ?
var current_gun_index = 0
var gun_selection = []

# TODO - generate this from Globals.GUN_INDEX
# Gun name, selection_weight, 1 - where 1 is a flag to designate if the gun is in the collection of not for the sampling algorithm
var gun_collection = [
		["DEV_CANON", 0.1, 1],
		["PISTOL_01", 1.0, 1],
		["MP7", 1.0, 1],
		["AUTO_SHOTGUN", 1.0, 1],
		["SPAS", 1.0, 1],
		["50_CAL", 1.0, 1]
	]
	

func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	player.money_component.money -= purchasable_cost
	Events.emit_signal("player_log", "Purchased " + purchasable_name)
	

	can_be_purchased = false
	gun_selection = select_guns()
	is_selecting = true
	return

func _process(delta):
	if !is_selecting:
		return
	
	if gun_switching_timer.is_stopped():
		gun_switching_timer.start()
		var gun_name = gun_selection[current_gun_index]
		gun_sprite.texture = Globals.GUN_INDEX[gun_name].sprite
		if len(gun_selection) - 1 > current_gun_index:
			current_gun_index += 1
		else:
			is_selecting = false
			end_selection()
		

func select_guns() -> Array:
	""" 
	Reservoir sampling with removal algorithm.
	https://saturncloud.io/blog/algorithm-for-o1-weighted-random-selection-with-removal/#:~:text=Generate%20a%20random%20number%20between,weight%20of%20the%20selected%20item.
	"""
	# Initialize the collection
	var collection = gun_collection.duplicate(true)
	
	# Initialize reservoir
	var reservoir = []
	
	# Sum the weights
	var sum_of_weights := 0.0
	for gun in collection:
		sum_of_weights += gun[1]
	
	# Repeat steps 4-6 until the desired number of items have been selected or the collection becomes empty.
	var collection_empty := false
	
	while true:
		if is_collection_empty(collection):
			break
		if len(reservoir) >= number_of_switches:
			break
	
		# For each gun, calc its weight as a fraction of the total sum of weights
		for gun in collection:
			# Skip guns which have been removed from the collection
			if gun[2] == 0:
				continue
				
			var gun_weight = gun[1] / sum_of_weights
		
			# Generate a random number between 0 and 1
			var random_num = randf_range(0, 1)
		
			# If the random number is less than or equal to the weight of the current item, add it to the reservoir 
			print(gun[0])
			print("Random num")
			print(random_num)
			print("Gun weight")
			print(gun_weight)
			
			if gun_weight >= random_num:
				reservoir.append(gun[0])
				# and remove it from the collection
				gun[2] = 0
				
				# Adjust the sum of weights by subtracting the weight of the selected item.
				sum_of_weights -= gun[1]
				
			if is_collection_empty(collection):
				break
			if len(reservoir) >= number_of_switches:
				break
	return reservoir

func is_collection_empty(collection):
	for gun in collection:
		# If any gun is still in the collection, then its not empty
		if gun[2] == 1:
			return false
	return true

func end_selection():
	""" Cleans up state after selecting the weapon. """
	is_selecting = false
	can_be_purchased = true
	current_gun_index = 0
	gun_switching_timer.stop()
	gun_selection = []
