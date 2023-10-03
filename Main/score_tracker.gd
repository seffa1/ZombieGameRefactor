extends Node

const SAVE_DIR = "user://highscore/"
var save_path = SAVE_DIR + "highscore.dat"


var score = {
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

var current_level: String

func _ready():
	Events.bullet_fired.connect(_on_bullet_fired)
	Events.bullet_hit.connect(_on_bullet_hit)
	Events.wave_started.connect(_on_wave_started)
	Events.zombie_death.connect(_on_zombie_death)
	Events.give_player_money.connect(_on_give_player_money)

	# Make highscore directory if it doesn't exists
	if !DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)

	match get_tree().get_current_scene().get_name():
		"GameInitializerDev":
			current_level = "DevTestChamber"
		"GameInitializerLabs":
			current_level = "TheLabs"
		_:
			assert(false, "Root name not handled: " + str(get_tree().get_current_scene().get_name()))

func updateHighScore():
	"""
	Load the current high score data if it exsits. Compare it to the currect score. 
	If we got a new high score returns true, else, 
	"""
	var newHighScore = false

	# if there is no save file we'll assume its a new highscore
	if !FileAccess.file_exists(save_path):
		newHighScore = true

	# If there is a save file, check if its a new highscore
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)

		if file == null:
			print("Error opening file:")
			print(FileAccess.get_open_error())
			return

		var oldSaveData = file.get_var()

		# if we got a new highest level, save current game data
		if score[current_level]["wave"] > oldSaveData[current_level]["wave"]:
			newHighScore = true

		# if we got the save level but more kills, save current game data
		elif score[current_level]["wave"] == oldSaveData[current_level]["wave"] and score[current_level]["kills"] > oldSaveData[current_level]["kills"]:
			newHighScore = true

	if newHighScore:
		# Save highscore data
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		
		if file == null:
			print("Error opening save file")
			print(FileAccess.get_open_error())
			return

		file.store_var(score)

func _on_bullet_fired():
	score[current_level]["bullets_fired"] += 1

var previous_RID: RID
var previous_random_id: int

func _on_bullet_hit(bullet_RID, random_id):
	
	# Filter out bullets that hit multiple times
	if previous_RID != bullet_RID or !previous_RID:

		# Filter out bullets that were fired at the same time ( prevents shotguns from counting as multiple bullet hits )
		if previous_random_id != random_id or !previous_random_id:
			score[current_level]["bullets_hit"] += 1
			Events.emit_signal("give_player_money", 10)  # Player gets 10 points for unique each bullet that hits

			previous_RID = bullet_RID
			previous_random_id = random_id



func _on_wave_started(wave_number: int, zombie_to_be_killed: int):
	score[current_level]["wave"] = wave_number

func _on_zombie_death(_zombie: CharacterBody2D):
	score[current_level]["kills"] += 1

func _on_give_player_money(money: int):
	score[current_level]["points"] += money

func get_score():
	return score
