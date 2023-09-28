extends Control

@onready var menu_sounds = $MenuSoundPlayer
@onready var vfx_audio = $VFXAudio

func open():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menu_sounds.play_open()
	show()
#	_show_lights()
	get_tree().paused = true
	set_process_input(true)
	vfx_audio.play_sound("sub_hit")

# Button Press Handlers ------------------------------

# For all buttons
func _on_Button_focus_entered():
	menu_sounds.play_confirm()

func _on_quit_pressed():
	Events.emit_signal("game_quit")

func _on_main_menu_pressed():
	Events.emit_signal("return_to_main_menu")
	
# Button Hover VFX ------------------------------

func _on_quit_mouse_entered():
	menu_sounds.play_hover()

func _on_main_menu_mouse_entered():
	menu_sounds.play_hover()
