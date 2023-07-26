extends CharacterBody2D

"""
This script mainly signals to the UI all player related info:
	 stamina, health, money, debug info

Also tracks all perks / power-up-modifiers the player recieves and relates
those modifiers to the WeaponContainer if they modify weapons.

Note, player should be below UI in the node tree so the UI is initialized
before we pass signals to it.
"""

# Signals
signal player_stamina_change(stamina: int)
signal player_money_change(money: int)
signal player_rotation_change(rotation)
signal player_position_change(position)
signal player_perks_change(perks: Array[String])

# Nodes
@onready var camera_transform = $CameraTransform
@onready var weapon_container = $WeaponContainer
@onready var animation_player = $AnimationPlayer

# Constants
@export var STARTING_MONEY: int = 10000

# Variables
var perks: Array[String] = []

var max_stamina: int = 100:
	set(value):
		max_stamina = value

@onready var stamina: int = 0:
	set(value):
		var new_stamina
		if value > max_stamina:
			new_stamina = max_stamina
		elif value < 0:
			new_stamina = 0
		else:
			new_stamina = value
		stamina = new_stamina
		emit_signal("player_stamina_change", new_stamina)

@onready var money: int = 0:
	set(value):
		var new_money
		if value < 0:
			new_money = 0
		else:
			new_money = value
		money = new_money
		emit_signal("player_money_change", money)
	get:
		return money

func assign_camera(camera: Camera2D) -> void:
	camera_transform.remote_path = camera.get_path()

func _physics_process(delta):
	emit_signal("player_rotation_change", self.rotation)
	emit_signal("player_position_change", self.position)

func _ready():
	# Call the settings to trigger change signals to update the HUD
	money = STARTING_MONEY
	stamina = max_stamina

func add_perk(perk_name: String):
	perks.append(perk_name)
	emit_signal("player_perks_change", perks)

