extends Control

"""
This node is only responsible for showing and hiding the sub menus. Each sub menu
is responsible for its button handlers.
"""

@onready var solo_level_select: Control = $SoloLevelSelect
@onready var settings: Control = $SettingsMenu
@onready var leaderboards: Control = $Leaderboards
@onready var menu_sounds: AudioStreamPlayer2D = $"../MenuSoundPlayer"

# Show and hide control for all menus ----------------------------------
func _ready():
	hide_all_menus()

func hide_all_menus():
	for menu in [solo_level_select, settings, leaderboards]:
		menu.hide()

func show_solo_level_select():
	hide_all_menus()
	solo_level_select.show()
	
func show_settings():
	hide_all_menus()
	settings.show()
	get_tree().paused = false

func show_leaderboards():
	hide_all_menus()
	leaderboards.show()

