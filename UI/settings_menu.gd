extends Control

@onready var menu_sounds = $MenuSoundPlayer
@onready var lights_container: Node = $VFX/lightsContainer
@onready var back_button: Button = $BackButton
@onready var reset_display_settings: Button = $ResetDisplay
@onready var reset_sound_settings: Button = $ResetSound
@onready var sound_sliders = $SoundOptions/Sliders
@onready var display_sliders = $DisplayOptions/Sliders

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED # This is how a pause menu works, see docs
	visible = false
	set_process_input(false)
	_hide_lights()
	Events.open_settings.connect(open)

func _hide_lights():
	for light in lights_container.get_children():
		light.enabled = false

func _show_lights():
	for light in lights_container.get_children():
		light.enabled = true

func open():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menu_sounds.play_open()
	show()
	_show_lights()
	get_tree().paused = true
	set_process_input(true)
	
func close():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	menu_sounds.play_close()
	_hide_lights()
	Events.emit_signal("game_resumed")


func _on_back_button_pressed():
	close()


func _on_reset_sound_pressed():
	for sound_slider in sound_sliders.get_children():
		sound_slider.reset()


func _on_reset_display_pressed():
	for display_slider in display_sliders.get_children():
		display_slider.reset()
