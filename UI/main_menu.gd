extends Control

"""
The main
"""

@onready var menu_sounds = $MenuSoundPlayer
@onready var music_audio = $MusicAudio
@onready var vfx_audio = $VFXAudio

@onready var solo: Button = $Solo
@onready var multiplayer_button: Button = $Multiplayer
@onready var leaderboards: Button = $Leaderboards
@onready var settings: Button = $Settings
@onready var quit_button: Button = $Quit
@onready var sub_screen = $SubScreenManager



# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	solo.toggle_flicker(true)
	print("READY - SETTING SUB HIT")
	vfx_audio.play_sound("sub_hit")
	music_audio.play_sound("piano_loop")
	for button in [solo, multiplayer_button, leaderboards, settings, quit_button]:
		button.focus_entered.connect(_on_Button_focus_entered)

# Button Press Handlers ------------------------------

# For all buttons
func _on_Button_focus_entered():
	menu_sounds.play_confirm()
	
func _on_solo_pressed():
	sub_screen.show_solo_level_select()
#	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
#	get_tree().change_scene_to_file("res://Main/Game.tscn")
	
func _on_settings_pressed():
	sub_screen.show_settings()

func _on_quit_pressed():
	get_tree().quit()


# Button Hover VFX ------------------------------
func _shut_all_button_flickers_off():
	for button in [solo, multiplayer_button, leaderboards, settings, quit_button]:
		button.toggle_flicker(false)

func _on_solo_mouse_entered():
	menu_sounds.play_hover()
	_shut_all_button_flickers_off()
	solo.toggle_flicker(true)

func _on_multiplayer_mouse_entered():
	menu_sounds.play_hover()
	_shut_all_button_flickers_off()
	multiplayer_button.toggle_flicker(true)

func _on_leaderboards_mouse_entered():
	menu_sounds.play_hover()
	_shut_all_button_flickers_off()
	leaderboards.toggle_flicker(true)

func _on_settings_mouse_entered():
	menu_sounds.play_hover()
	_shut_all_button_flickers_off()
	settings.toggle_flicker(true)

func _on_quit_mouse_entered():
	menu_sounds.play_hover()
	_shut_all_button_flickers_off()
	quit_button.toggle_flicker(true)


