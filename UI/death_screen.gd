extends Control

@export var score_tracker: Node

@onready var menu_sounds = $MenuSoundPlayer
@onready var vfx_audio = $VFXAudio

@onready var wave_number = $HBoxContainer/VBoxContainer2/waveNumber
@onready var kill_count = $HBoxContainer/VBoxContainer2/killCount
@onready var points_earned = $HBoxContainer/VBoxContainer2/pointsEarned
@onready var shots_fired = $HBoxContainer/VBoxContainer2/shotsFired
@onready var accuracy = $HBoxContainer/VBoxContainer2/accuracy

func open():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menu_sounds.play_open()
	show()
#	_show_lights()
	get_tree().paused = true
	set_process_input(true)
	vfx_audio.play_sound("sub_hit")

	score_tracker.updateHighScore()
	var score = score_tracker.get_score()
	populate_highscore(score)

func populate_highscore(score):
	#var score = {
	#	"bullets_fired": 0,
	#	"bullets_hit": 0,
	#	"wave": 1,
	#	"kills": 0,
#		"points": 0
	#}
	wave_number.text = str(score["wave"])
	kill_count.text = str(score["kills"])
	points_earned.text = str(score["points"])
	shots_fired.text = str(score["bullets_fired"])
	
	var accuracy_label = round(( float(score["bullets_hit"]) / float(score["bullets_fired"])) * 100 )
	accuracy.text = str(accuracy_label) + " %"

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

