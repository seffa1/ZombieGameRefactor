extends Node

@onready var camera = $GameWorld/Camera
@onready var player = $GameWorld/Player
@onready var UI = $UI
@onready var screen_shaker = $ScreenShaker
@onready var pause_menu = $UI/PauseMenu

func _ready():
	Globals.player = player
	player.assign_camera(camera)
	
	screen_shaker.camera = camera

func _input(event):
	if event.is_action_pressed("pause"):
		pause_menu.show()
		get_tree().paused = true
		
