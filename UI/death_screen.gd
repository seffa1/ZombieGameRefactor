extends Control

@export var score_tracker: Node

@onready var menu_sounds = $MenuSoundPlayer
@onready var vfx_audio = $VFXAudio

@onready var wave_number = $HBoxContainer/VBoxContainer2/waveNumber
@onready var kill_count = $HBoxContainer/VBoxContainer2/killCount
@onready var points_earned = $HBoxContainer/VBoxContainer2/pointsEarned
@onready var shots_fired = $HBoxContainer/VBoxContainer2/shotsFired
@onready var accuracy = $HBoxContainer/VBoxContainer2/accuracy

@onready var previousBest_wave_number = $HBoxContainer/VBoxContainer4/highscoreWaveNumber
@onready var previousBest_kill_count = $HBoxContainer/VBoxContainer4/highscoreKillCount
@onready var previousBest_points_earned = $HBoxContainer/VBoxContainer4/highscorePointsEarned
@onready var previousBest_shots_fired = $HBoxContainer/VBoxContainer4/highscoreShotsFired
@onready var previousBest_accuracy = $HBoxContainer/VBoxContainer4/highschoreAccuracy

const SAVE_DIR = "user://highscore/"
var save_path = SAVE_DIR + "highscore.dat"

func open():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menu_sounds.play_open()
	show()
#	_show_lights()
	get_tree().paused = true
	set_process_input(true)
	vfx_audio.play_sound("sub_hit")

	
	var score = score_tracker.get_score()
	score_tracker.updateHighScore()
	var previousBest = getHighScoreData()
	populate_highscore(score, previousBest)

func getHighScoreData():
	if !FileAccess.file_exists(save_path):
		return null

	var file = FileAccess.open(save_path, FileAccess.READ)

	if file == null:
		print("Error opening file:")
		print(FileAccess.get_open_error())
		return null

	return file.get_var()

func populate_highscore(score, previousBest):
	#var score = {
	#	"bullets_fired": 0,
	#	"bullets_hit": 0,
	#	"wave": 1,
	#	"kills": 0,
#		"points": 0
	#}
	# Populate current score
	wave_number.text = str(score["wave"])
	kill_count.text = str(score["kills"])
	points_earned.text = str(score["points"])
	shots_fired.text = str(score["bullets_fired"])
	
	var accuracy_label
	if score["bullets_fired"] == 0:
		accuracy_label = 0
	else:
		accuracy_label = round(( float(score["bullets_hit"]) / float(score["bullets_fired"])) * 100 )
	accuracy.text = str(accuracy_label) + " %"

	# Populate previous best score
	if previousBest:
		previousBest_wave_number.text = str(previousBest["wave"])
		previousBest_kill_count.text = str(previousBest["kills"])
		previousBest_points_earned.text = str(previousBest["points"])
		previousBest_shots_fired.text = str(previousBest["bullets_fired"])
		
		var previous_best_accuracy_label
		if previousBest["bullets_fired"] == 0:
			previous_best_accuracy_label = 0
		else:
			previous_best_accuracy_label = round(( float(previousBest["bullets_hit"]) / float(previousBest["bullets_fired"])) * 100 )
		previousBest_accuracy.text = str(previous_best_accuracy_label) + " %"


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

