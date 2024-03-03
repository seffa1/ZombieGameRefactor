extends Node

@onready var camera = $GameWorld/Camera
@onready var player = $GameWorld/Player
@onready var UI = $UI
@onready var screen_shaker = $ScreenShaker
@onready var vinette = $GameWorld/Darkness/vinette
@onready var hud = $UI/HUD

@export var remove_vinette: bool = false

func _ready():
	Globals.player = player
	screen_shaker.camera = camera
	
	if !remove_vinette:
		vinette.show()

	# Initialilze all HUD elements
	hud.show()
	var player_gun = player.weapon_manager.get_equipped_gun()
	var nice_weapon_name =  Globals.GUN_INDEX[player_gun.WEAPON_NAME].nice_name
	Events.emit_signal("player_equipped_clip_count_change", player_gun.bullets_in_clip)
	Events.emit_signal("player_equipped_reserve_count_change", player_gun.bullet_reserve)
	Events.emit_signal("player_equipped_change", nice_weapon_name, player_gun.weapon_level, player_gun.get_modifier())
	Events.emit_signal("player_money_change", player.money_component.money)
	
