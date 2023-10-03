extends Control

@onready var score_wave = $VBoxContainer/HBoxContainer/VBoxContainer2/waveNumber
@onready var score_kills = $VBoxContainer/HBoxContainer/VBoxContainer2/killCount
@onready var score_points = $VBoxContainer/HBoxContainer/VBoxContainer2/pointsEarned
@onready var score_shotsFired = $VBoxContainer/HBoxContainer/VBoxContainer2/shotsFired
@onready var score_accuracy = $VBoxContainer/HBoxContainer/VBoxContainer2/accuracy

const SAVE_DIR = "user://highscore/"
var save_path = SAVE_DIR + "highscore.dat"


var highscore = {
	"TheLabs": {
		"bullets_fired": 0,
		"bullets_hit": 0,
		"wave": 1,
		"kills": 0,
		"points": 0
	},
	"DevTestChamber": {
		"bullets_fired": 0,
		"bullets_hit": 0,
		"wave": 1,
		"kills": 0,
		"points": 0
	},
}

func _ready():
	loadHighScoreData()
	
	# TODO - if we ever get more levels, this will have to be dynamic

	score_wave.text = str(highscore["TheLabs"]["wave"])
	score_kills.text = str(highscore["TheLabs"]["kills"])
	score_points.text = str(highscore["TheLabs"]["points"])
	score_shotsFired.text = str(highscore["TheLabs"]["bullets_fired"])

	var accuracy_label
	if highscore["TheLabs"]["bullets_fired"] == 0:
		accuracy_label = 0
	else:
		accuracy_label = round(( float(highscore["TheLabs"]["bullets_hit"]) / float(highscore["TheLabs"]["bullets_fired"])) * 100 )

	score_accuracy.text = str(accuracy_label) + " %"

func loadHighScoreData():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)

		if file == null:
			print("Error opening file:")
			print(FileAccess.get_open_error())
			return

		highscore = file.get_var()

