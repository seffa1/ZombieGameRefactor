extends Control

"""
The main
"""

@onready var menu_sounds = $MenuSoundPlayer
@onready var solo: Button = $Solo
@onready var multiplayer_button: Button = $MultiPlayer
@onready var leaderboards: Button = $Leaderboards
@onready var settings: Button = $Settings
@onready var quit: Button = $Quit



# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED # This is how a pause menu works, see docs
	visible = true
	set_process_input(true)
	
#	for button in [solo, multiplayer_button, leaderboards, settings, quit]:
#		button.focus_entered.connect(_on_Button_focus_entered)

func _on_Button_focus_entered():
	menu_sounds.play_hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_solo_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	pass # Replace with function body.
