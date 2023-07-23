extends CharacterBody2D

# Signals
signal player_stamina_change(stamina: int)

# Nodes
@onready var camera_transform = $CameraTransform

# Constants
var MAX_STAMINA: int = 100

# Variables
@onready var stamina: int = 100:
	set(value):
		var new_stamina
		if value > MAX_STAMINA:
			new_stamina = MAX_STAMINA
		elif value < 0:
			new_stamina = 0
		else:
			new_stamina = value
		stamina = new_stamina
		print("Player stamina changed: " + str(new_stamina))
		emit_signal("player_stamina_change", new_stamina)


func assign_camera(camera: Camera2D) -> void:
	camera_transform.remote_path = camera.get_path()
