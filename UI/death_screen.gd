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

var current_level

func open():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menu_sounds.play_open()
	show()

	get_tree().paused = true
	set_process_input(true)
	vfx_audio.play_sound("sub_hit")

	var score = score_tracker.get_score()
	print('Round score:')
	print(score)
	current_level = score_tracker.current_level
	score_tracker.updateHighScore()
	var previousBest = getHighScoreData()
	print('Previous Best:')
	print(previousBest)
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
	# Populate current score
	wave_number.text = str(score[current_level]["wave"])
	kill_count.text = str(score[current_level]["kills"])
	points_earned.text = str(score[current_level]["points"])
	shots_fired.text = str(score[current_level]["bullets_fired"])
	
	var accuracy_label
	if score[current_level]["bullets_fired"] == 0:
		accuracy_label = 0
	else:
		accuracy_label = round(( float(score[current_level]["bullets_hit"]) / float(score[current_level]["bullets_fired"])) * 100 )
	accuracy.text = str(accuracy_label) + " %"

	# Populate previous best score
	if previousBest:
		previousBest_wave_number.text = str(previousBest[current_level]["wave"])
		previousBest_kill_count.text = str(previousBest[current_level]["kills"])
		previousBest_points_earned.text = str(previousBest[current_level]["points"])
		previousBest_shots_fired.text = str(previousBest[current_level]["bullets_fired"])
		
		var previous_best_accuracy_label
		if previousBest[current_level]["bullets_fired"] == 0:
			previous_best_accuracy_label = 0
		else:
			previous_best_accuracy_label = round(( float(previousBest[current_level]["bullets_hit"]) / float(previousBest[current_level]["bullets_fired"])) * 100 )
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

