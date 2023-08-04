extends Control

@onready var resume_button = $ResumeButton
@onready var quit_button = $QuitButton
@onready var menu_sounds = $MenuSoundPlayer

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED # This is how a pause menu works, see docs
	visible = false
	set_process_input(false)
	
	for button in [resume_button, quit_button]:
		button.focus_entered.connect(_on_Button_focus_entered)

func open():
	menu_sounds.play_open()
	show()
	get_tree().paused = true
	set_process_input(true)
	
func close():
	menu_sounds.play_close()
	Events.emit_signal("game_resumed")

func _on_resume_button_pressed():
	close()

func _on_quit_button_pressed():
	Events.emit_signal("game_quit")

func _input(event: InputEvent):
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		close()

func _on_Button_focus_entered():
	menu_sounds.play_hide()
