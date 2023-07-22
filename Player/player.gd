extends CharacterBody2D

var MAX_STAMINA: int = 100

@onready var stamina: int = 100:
	set(value):
		if value > MAX_STAMINA:
			stamina = MAX_STAMINA
		elif value < 0:
			stamina = 0
		else:
			stamina = value
			
@onready var camera_transform = $CameraTransform

func assign_camera(camera: Camera2D) -> void:
	camera_transform.remote_path = camera.get_path()
