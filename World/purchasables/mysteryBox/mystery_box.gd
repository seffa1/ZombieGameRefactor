extends "res://World/purchasables/purchasable.gd"

"""
Must add mystery box locations to the scene and assign them to the export variable.
Buying the box is considered 'spining it'
"""

@onready var gun_switching_timer: Timer = $gunSwitchingTimer
@onready var gun_sprite: Sprite2D = $GunSelectionSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $Audio
@onready var mystery_box_pickup_scene = preload("res://World/purchasables/mysteryBox/MysteryBoxPickup.tscn")

@export var number_of_switches: int = 4  # how many guns does the box cycle through before giving you one ?
@export var mystery_box_locations: Array[Node2D]
@export var min_spins_until_move: float = 5.0  # Gaurenteed spins of the box before it has a change to move locations
@export var max_spins_until_mov: float = 15.0 # most spins you get before the next spin it gaurenteed to move the box

var spins_since_moving = 0
var is_selecting: bool = false  # Is the mystery currently seleting a weapon to give the player ?
var gun_selection = []  # populated by random gun selection algorithm
var current_gun_index = 0  # used to cycle through the selected guns
var mystery_box_pickup = null  # a refernece to the spawned in weapon pick up node
var player_buying_mystery_box = null  # Reference to the player who bought the box, so only they can pick it up
var selected_location  # reference to the current mystery box location

func _ready():
	# Get mystery boxes with a starting location flag set
	var starting_locations = []

	assert(len(mystery_box_locations) > 0, "Make sure to link locations to the box via the export array!")
	
	for location in mystery_box_locations:
		if location.is_starting_location:
			starting_locations.append(location)
	
	assert(len(starting_locations) > 0, "At least one location needs to be a starting location!")
	
		
	# Set position to random starting location position
	var random_index = randi_range(0, len(starting_locations) - 1)
	selected_location = starting_locations[random_index]
	global_position = selected_location.global_position
	rotation = selected_location.rotation
	
	# Mark location as current and visited
	selected_location.is_current_box_location = true
	selected_location.visited = true

func move_locations():
	# Get loctions which have not been visited yet
	var unvisited_locations = []
	for location in mystery_box_locations:
		if location.visited == false:
			unvisited_locations.append(location)
	
	# Find the new location, making sure we dont visit the same location twice before visiting all, 
	# and not the same one twice in a row
	var new_location
	
	# If we still havent visited all locations
	if len(unvisited_locations) > 0:
		var random_index = randi_range(0, len(unvisited_locations) - 1)
		new_location = unvisited_locations[random_index]
	
	# If every location has been visited,
	else:
		# reset all visited flags...
		var all_locations_except_current = []
		for location in mystery_box_locations:
			location.visited = false
			
			# ...and get all locations which are NOT the current location
			if !location.is_current_box_location:
				all_locations_except_current.append(location)

		# Then choose from among these locations
		assert(len(all_locations_except_current) > 0, "We should never be here.....")
		var random_index = randi_range(0, len(all_locations_except_current) - 1)
		new_location = all_locations_except_current[random_index]
	
	# Reset the old location back to 'not current location'
	selected_location.is_current_box_location = false
	
	# update the selected location reference to the new location
	selected_location = new_location
	
	# Mark it as current and visited
	selected_location.is_current_box_location = true
	selected_location.visited = true
	
	# Start the animation
	animation_player.play("move_locations")

func _on_move_locations_animation_finished():
	# Update the position
	global_position = selected_location.global_position
	rotation = selected_location.rotation
	
	# Start the box arrival animation
	animation_player.play("box_arrival")
	
	# Clean up the state so player can buy again
	end_selection()

func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	player.money_component.money -= purchasable_cost
	Events.emit_signal("player_log", "Purchased " + purchasable_name)
	player_buying_mystery_box = player
	
	can_be_purchased = false
	audio.play_buy()
	
	spins_since_moving += 1

	var chance_to_move
	var should_box_move

	if spins_since_moving >= max_spins_until_mov:
		should_box_move = true
	elif spins_since_moving < min_spins_until_move:
		should_box_move = false
	else:
		# Change to move increases from 0 to 100 percent as the spins going from the min to the max
		chance_to_move = (100.0 / (max_spins_until_mov - min_spins_until_move)) * (spins_since_moving - min_spins_until_move)
		var random_chance = randf_range(0, 100)
		if chance_to_move >= random_chance:
			should_box_move = true
	
	if should_box_move:
		# Give player their money back
		Events.emit_signal("give_player_money", purchasable_cost)
		move_locations()
		spins_since_moving = 0
	else:
		gun_selection = select_guns()
		is_selecting = true
	
	return

func _process(delta):
	if !is_selecting:
		return
	
	if is_selecting:
		# Cycle through the differnet guns until we get to the last one
		if gun_switching_timer.is_stopped():
			gun_switching_timer.start()
			var gun_name = gun_selection[current_gun_index]
			gun_sprite.texture = Globals.GUN_INDEX[gun_name].pickup_sprite
			if len(gun_selection) - 1 > current_gun_index:
				audio.play_gun_switch()
				current_gun_index += 1
			else:
				audio.play_gun_selection()
				# Instantiate a wepaon buy for the chosen weapon
				mystery_box_pickup = mystery_box_pickup_scene.instantiate()
				mystery_box_pickup.weapon_name = gun_name
				mystery_box_pickup.rotation = rotation
				mystery_box_pickup.mystery_box_weapon_picked_up.connect(_on_weapon_picked_up)
				add_child(mystery_box_pickup)
				# Then switch to the 'is giving state'
				animation_player.play("pickup_timer")
				is_selecting = false

# If the player DOESNT pickup the gun before the timer runs out
func _on_pickup_animation_finished():
	gun_sprite.texture = null
	mystery_box_pickup.queue_free()
	animation_player.play("close")

# If the player DID pickup the gun from the box
func _on_weapon_picked_up():
	# The weapon buy will have queue_freed itself on pickup
	audio.play_gun_pickup() # TODO - this maybe should be unique to each gun ?
	gun_sprite.texture = null
	animation_player.play("RESET")
	animation_player.play("close")

func _on_close_animation_finished():
	audio.play_closed()
	end_selection()

func select_guns() -> Array:
	""" 
	Reservoir sampling. We are NOT doing removal, this is so the same gun and get spun multiple times, just like in COD.
	https://saturncloud.io/blog/algorithm-for-o1-weighted-random-selection-with-removal/#:~:text=Generate%20a%20random%20number%20between,weight%20of%20the%20selected%20item.
	"""
	# Initialize the collection (term from the sample algorithm blog post above)
	var collection = Globals.mystery_box_spawn_weights.duplicate(true)
	
	# Set weight to 0 for any gun the player already has so they don't spin it again
	for gun in collection:
		var gun_name = gun[0]
		if player_buying_mystery_box.weapon_manager.has_gun(gun_name):
			gun[1] = 0.0
			
	assert(!all_weights_zero(collection), "All guns weights are zero, you would go into an infinite loop!")

	# Initialize reservoir (term from the sample algorithm blog post above)
	var reservoir = []
	
	# Sum the weights
	var sum_of_weights := 0.0
	for gun in collection:
		sum_of_weights += gun[1]
	
	# Repeat steps 4-6 until the desired number of items have been selected or the collection becomes empty.
	var collection_empty := false
	
	while true:
		# Keep selecting until we have selected enough weapons
		if len(reservoir) >= number_of_switches:
			break
	
		# For each gun, calc its weight as a fraction of the total sum of weights
		for gun in collection:
				
			var gun_weight = gun[1] / sum_of_weights
		
			# Generate a random number between 0 and 1
			var random_num = randf_range(0, 1)
		
			# If the random number is less than or equal to the weight of the current item, add it to the reservoir 
			if gun_weight >= random_num:
				reservoir.append(gun[0])

			if len(reservoir) >= number_of_switches:
				break
	return reservoir

func all_weights_zero(collection):
	for gun in collection:
		# If any gun still has weight, then its not all zero
		if gun[1] > 0.0:
			return false
	return true

func end_selection():
	""" Cleans up state after selecting the weapon. """
	gun_sprite.texture = null
	is_selecting = false
	can_be_purchased = true
	mystery_box_pickup = null
	current_gun_index = 0
	gun_switching_timer.stop()
	gun_selection = []
	player_buying_mystery_box = null
