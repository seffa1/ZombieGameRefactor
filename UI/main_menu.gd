extends Control

"""
The main
"""

@onready var menu_sounds = $MenuSoundPlayer
@onready var solo: Button = $Solo
@onready var multiplayer_button: Button = $Multiplayer
@onready var leaderboards: Button = $Leaderboards
@onready var settings: Button = $Settings
@onready var quit_button: Button = $Quit


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	solo.toggle_flicker(true)
	
	for button in [solo, multiplayer_button, leaderboards, settings, quit_button]:
		button.focus_entered.connect(_on_Button_focus_entered)

func _on_Button_focus_entered():
	menu_sounds.play_hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Button Press Handlers ------------------------------
func _on_solo_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().change_scene_to_file("res://Main/Game.tscn")

func _on_quit_pressed():
	get_tree().quit()


# Button Hover VFX ------------------------------
func _shut_all_button_flickers_off():
	for button in [solo, multiplayer_button, leaderboards, settings, quit_button]:
		button.toggle_flicker(false)

func _on_solo_mouse_entered():
	_shut_all_button_flickers_off()
	solo.toggle_flicker(true)

func _on_multiplayer_mouse_entered():
	_shut_all_button_flickers_off()
	multiplayer_button.toggle_flicker(true)

func _on_leaderboards_mouse_entered():
	_shut_all_button_flickers_off()
	leaderboards.toggle_flicker(true)

func _on_settings_mouse_entered():
	_shut_all_button_flickers_off()
	settings.toggle_flicker(true)

func _on_quit_mouse_entered():
	_shut_all_button_flickers_off()
	quit_button.toggle_flicker(true)
