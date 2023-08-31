extends "res://World/purchasables/purchasable.gd"

@onready var gun_switching_timer: Timer = $gunSwitchingTimer
@onready var gun_sprite: Sprite2D = $GunSelectionSprite
@onready var gun_pickup_timer: Timer = $gunPickupTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $Audio

@onready var mystery_box_pickup_scene = preload("res://World/purchasables/mysteryBox/MysteryBoxPickup.tscn")

@export var number_of_switches: int = 4  # how many guns does the box cycle through before giving you one ?


var is_selecting: bool = false  # Is the mystery currently seleting a weapon to give the player ?
var current_gun_index = 0
var gun_selection = []
var mystery_box_pickup = null
var player_buying_mystery_box = null

# TODO - generate this from Globals.GUN_INDEX
# Gun name, selection_weight
var gun_collection = [
		["DEV_CANON", 0.1],
		["PISTOL_01", 1.0],
		["MP7", 1.0],
		["AUTO_SHOTGUN", 1.0],
		["SPAS", 1.0],
		["50_CAL", 1.0]
	]
	

func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	player.money_component.money -= purchasable_cost
	Events.emit_signal("player_log", "Purchased " + purchasable_name)
	player_buying_mystery_box = player
	
	can_be_purchased = false
	gun_selection = select_guns()
	is_selecting = true
	audio.play_buy()
	return

func _process(delta):
	if !is_selecting:
		return
	
	if is_selecting:
		# Cycle through the differnet guns until we get to the last one
		if gun_switching_timer.is_stopped():
			gun_switching_timer.start()
			var gun_name = gun_selection[current_gun_index]
			gun_sprite.texture = Globals.GUN_INDEX[gun_name].sprite
			if len(gun_selection) - 1 > current_gun_index:
				audio.play_gun_switch()
				current_gun_index += 1
			else:
				audio.play_gun_selection()
				# Instantiate a wepaon buy for the chosen weapon
				mystery_box_pickup = mystery_box_pickup_scene.instantiate()
				mystery_box_pickup.weapon_name = gun_name
				mystery_box_pickup.rotation = rotation
				mystery_box_pickup.purchasable_cost = 0
				mystery_box_pickup.purchasable_name = 'Pickup ' + gun_name
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
	# Initialize the collection
	var collection = gun_collection.duplicate(true)
	
	# Set weight to 0 for any gun the player already has so they don't spin it again
	for gun in collection:
		var gun_name = gun[0]
		if player_buying_mystery_box.weapon_manager.has_gun(gun_name):
			gun[1] = 0.0
			
	assert(!all_weights_zero(collection), "All guns weights are zero, you would go into an infinite loop!")

	# Initialize reservoir
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
	animation_player.stop()
	mystery_box_pickup = null
	current_gun_index = 0
	gun_switching_timer.stop()
	gun_selection = []
	player_buying_mystery_box = null
