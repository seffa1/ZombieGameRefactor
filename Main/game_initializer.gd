extends Node

@onready var camera = $GameWorld/Camera
@onready var player = $GameWorld/Player
@onready var UI = $UI
@onready var screen_shaker = $ScreenShaker
@onready var vinette = $GameWorld/Darkness/vinette
@onready var hud = $UI/HUD

@export var remove_vinette: bool = false
@export var start_with_keycard: bool = false

func _ready():
	Globals.player = player
	screen_shaker.camera = camera
	
	if !remove_vinette:
		vinette.show()
	if start_with_keycard:
		Globals.has_keycard = true

	# Initialilze all HUD elements
	hud.show()
	var player_gun = player.weapon_manager.get_equipped_gun()

	Events.emit_signal("player_equipped_clip_count_change", player_gun.bullets_in_clip)
	Events.emit_signal("player_equipped_reserve_count_change", player_gun.bullet_reserve)
	Events.emit_signal("player_equipped_change", player_gun.WEAPON_NAME, player_gun.weapon_level, '')
	Events.emit_signal("player_money_change", player.money_component.money)
	


