extends Node

@onready var camera = $GameWorld/Camera
@onready var player = $GameWorld/Player
@onready var UI = $UI
@onready var screen_shaker = $ScreenShaker


func _ready():
	Globals.player = player
#	player.assign_camera(camera)
	
#	camera.assign_player(player)
	
	screen_shaker.camera = camera

