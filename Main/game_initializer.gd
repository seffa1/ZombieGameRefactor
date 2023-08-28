extends Node

@onready var camera = $GameWorld/Camera
@onready var player = $GameWorld/Player
@onready var UI = $UI
@onready var screen_shaker = $ScreenShaker
@onready var vinette = $GameWorld/Darkness/vinette

func _ready():
	Globals.player = player
	screen_shaker.camera = camera
	vinette.show()
	
	

