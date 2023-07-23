extends Node

@onready var camera = $GameWorld/Camera
@onready var player = $GameWorld/Player
@onready var UI = $UI

func _ready():
	Globals.player = player
	player.assign_camera(camera)
	
