extends Control

@onready var menu_sounds = $MenuSoundPlayer
@onready var lights_container: Node = $VFX/lightsContainer
@onready var quit_button: Button = $HBoxContainer/QuitButton/Quit
@onready var main_menu_button: Button = $HBoxContainer/BackToMain/MainMenu
@onready var reset_display_settings: Button = $DisplayOptions/ResetDisplay
@onready var reset_sound_settings: Button = $SoundOptions/ResetSound
@onready var sound_sliders = $SoundOptions/Sliders
@onready var display_sliders = $DisplayOptions/Sliders

@export var sub_menu: bool = false

func _ready():
	# If a sub menu ( in the main menu ), then hide the quit buttons and have it process always (instead of when the game is paused)
	if sub_menu:
		quit_button.get_parent().hide()
		main_menu_button.get_parent().hide()
		process_mode = Node.PROCESS_MODE_INHERIT # Use as a normal menu within the main menu
	else:
		process_mode = Node.PROCESS_MODE_WHEN_PAUSED # This is how a pause menu works, see docs
	visible = false
	set_process_input(false)
	_hide_lights()

	for button in [quit_button, reset_display_settings, reset_sound_settings, main_menu_button]:
		button.focus_entered.connect(_on_Button_focus_entered)
		
# Toggle Menu On / Off ------------------------------

func open():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menu_sounds.play_open()
	show()
	_show_lights()
	get_tree().paused = true
	set_process_input(true)

# Close menu with esc key
func _input(event: InputEvent):
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		close()

func close():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	_hide_lights()
	Events.emit_signal("game_resumed")



# Button Press Handlers ------------------------------

# For all buttons
func _on_Button_focus_entered():
	menu_sounds.play_confirm()

func _on_quit_pressed():
	Events.emit_signal("game_quit")
	
func _on_reset_sound_pressed():
	for sound_slider in sound_sliders.get_children():
		sound_slider.reset()

func _on_reset_display_pressed():
	for display_slider in display_sliders.get_children():
		display_slider.reset()

func _on_main_menu_pressed():
	Events.emit_signal("return_to_main_menu")

# Button Hover VFX ------------------------------

func _on_quit_mouse_entered():
	menu_sounds.play_hover()
	
func _on_reset_display_mouse_entered():
	menu_sounds.play_hover()

func _on_reset_sound_mouse_entered():
	menu_sounds.play_hover()
	
func _on_main_menu_mouse_entered():
	menu_sounds.play_hover()


# VFX Toggles ------------------------------

func _hide_lights():
	for light in lights_container.get_children():
		light.enabled = false

func _show_lights():
	for light in lights_container.get_children():
		light.enabled = true















