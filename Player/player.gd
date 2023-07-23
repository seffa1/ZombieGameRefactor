extends CharacterBody2D

"""
This script mainly signals to the UI all player related info:
	 stamina, health, money, debug info

Also tracks all perks / power-up-modifiers the player recieves and relates
those modifiers to the WeaponContainer if they modify weapons.
"""

# Signals
signal player_stamina_change(stamina: int)
signal player_money_change(money: int)
signal player_rotation_change(rotation)
signal player_position_change(position)

# Nodes
@onready var camera_transform = $CameraTransform

# Constants


# Variables
var max_stamina: int = 100:
	set(value):
		max_stamina = value

@onready var stamina: int = 100:
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

@onready var money: int = 10000:
	set(value):
		if value < 0:
			money = 0
		else:
			money = value
		emit_signal("player_money_change", money)

func assign_camera(camera: Camera2D) -> void:
	camera_transform.remote_path = camera.get_path()

func _physics_process(delta):
	emit_signal("player_rotation_change", self.rotation)
	emit_signal("player_position_change", self.position)
