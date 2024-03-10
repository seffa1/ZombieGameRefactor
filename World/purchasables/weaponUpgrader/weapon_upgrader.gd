extends "res://World/purchasables/purchasable.gd"

@onready var gun_selection_sprite: Sprite2D = $GunSelectionSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_pickup_scene = preload("res://World/purchasables/weaponUpgrader/WeaponUpgraderPickup.tscn")
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var first_upgrade_cost: int = 5000
@export var second_upgrade_cost: int = 2500
@export var third_upgrade_cost: int = 2500

var is_activated: bool = false  # can the player use the weapon upgrader?

var interactable_message: String  # set in process function
var weapon_to_upgrade: String  # store the name of the weapon we are upgrading
var level_upgrading_to: int  # store the NEW level of the gun we are upgrading
var weapon_pickup

func purchase_item(player: CharacterBody2D) -> void:
	"""
	Overriding parent method.
	"""
	
	if !can_be_purchased:
		return
	
	if !Globals.has_keycard:
		Events.emit_signal("player_log", "Keycard Required")
		return
	
	if !player.weapon_manager.has_a_gun():
		Events.emit_signal("player_log", "No gun to upgrade")
		return

	if player.money_component.money < purchasable_cost:
		Events.emit_signal("player_log", "Not enough money")
		return
	give_item(player)

func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	player.money_component.money -= purchasable_cost
	Events.emit_signal("player_log", "Upgraded " + purchasable_name)
	
	# Disable purchasing
	can_be_purchased = false
	
	# Play audio
	audio.play_buy()
	
	# Get required weapon information
	var weapon = player.weapon_manager.get_equipped_gun()
	weapon_to_upgrade = weapon.WEAPON_NAME

	# base=0, first_upgrade=1, second_upgrade=2 (max)
	if weapon.weapon_level == 2:
		level_upgrading_to = 2
	else:
		level_upgrading_to = weapon.weapon_level + 1

	# Remove gun from player
	player.weapon_manager.put_gun_in_upgraded()
	
	# Set the selection sprite
	# TODO - we probably want the 'upgraded looking sprite' presented to the player to pickup here
	gun_selection_sprite.texture = Globals.GUN_INDEX[weapon_to_upgrade].pickup_sprite
	
	# Start the animation
	animation_player.play("upgrade")

func _on_upgrade_animation_complete():
	_spawn_weapon_pickup()
	animation_player.play("pickup")

func _spawn_weapon_pickup():
	# Instantiate a weapon buy for the chosen weapon
	weapon_pickup = weapon_pickup_scene.instantiate()
	weapon_pickup.weapon_name = weapon_to_upgrade
	weapon_pickup.rotation = rotation
	weapon_pickup.mystery_box_weapon_picked_up.connect(_on_weapon_picked_up)
	weapon_pickup.weapon_level = level_upgrading_to
	add_child(weapon_pickup)

# If the player DOESNT pick the gun up in time
func _on_pickup_animation_complete():
	gun_selection_sprite.texture = null
	weapon_pickup.queue_free()
	reset_upgrader()

# If the player DOES pick the gun up in time
func _on_weapon_picked_up():
	animation_player.stop()
	audio.play_gun_pickup()
	gun_selection_sprite.texture = null
	animation_player.play("reset_upgrader")

func _on_reset_upgrader_animation_finished():
	"""
	This short animation is needed so when the player pickups the gun they dont 
	automatically upgrade the gun again at the same time.
	"""
	reset_upgrader()

func reset_upgrader():
	can_be_purchased = true
	weapon_to_upgrade = ''
	level_upgrading_to = 1
	weapon_pickup = null

func get_interactable_message(player: CharacterBody2D) -> String:
	if can_be_purchased:
		return interactable_message
	else:
		return ""

func _process(delta):
	# Only process if the player is in range to buy
	if !has_overlapping_bodies() or !can_be_purchased:
		purchasable_name = ''
		return
	
	if !Globals.has_keycard:
		interactable_message = 'Keycard Required'
		return

	assert(len(get_overlapping_bodies()) == 1, "Why are two things overlapping the purchasable?")
	var player = get_overlapping_bodies()[0]

	# Update buy message and cost
	if player.weapon_manager.has_a_gun():
		var weapon_object = player.weapon_manager.get_equipped_gun()
		purchasable_name = Globals.GUN_INDEX[weapon_object.WEAPON_NAME].nice_name
		match weapon_object.weapon_level:
			0:  # First upgrade
				purchasable_cost = first_upgrade_cost
				interactable_message =  "Upgrade " + purchasable_name + ": " + str(purchasable_cost)
			1:  # Second upgrade
				purchasable_cost = second_upgrade_cost
				interactable_message =  "Randomize modifier " + purchasable_name + ": " + str(purchasable_cost)
			2:  # upgraded once
				purchasable_cost = second_upgrade_cost
				interactable_message =  "Randomize modifier " + purchasable_name + ": " + str(purchasable_cost)
			_:
				assert(false, "Trying to upgrade a gun to a level that doesn't exist!")
