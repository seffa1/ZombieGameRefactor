extends Node

const SAVE_DIR = "user://highscore/"
var save_path = SAVE_DIR + "highscore.dat"


var score = {
	"bullets_fired": 0,
	"bullets_hit": 0,
	"wave": 1,
	"kills": 0,
	"points": 0
}

func _ready():
	Events.bullet_fired.connect(_on_bullet_fired)
	Events.bullet_hit.connect(_on_bullet_hit)
	Events.wave_started.connect(_on_wave_started)
	Events.zombie_death.connect(_on_zombie_death)
	Events.give_player_money.connect(_on_give_player_money)

	# Make highscore directory if it doesn't exists
	if !DirAccess.dir_exists_absolute(SAVE_DIR):
		print("Highscore directory doesnt exist, creating it...")
		DirAccess.make_dir_absolute(SAVE_DIR)

func updateHighScore():
	"""
	Load the current high score data if it exsits. Compare it to the currect score. 
	If we got a new high score returns true, else, 
	"""
	var newHighScore = false

	# if there is no save file we'll assume its a new highscore
	if !FileAccess.file_exists(save_path):
		print("Existing highscore save file not found, assuming new highscore")
		newHighScore = true

	# If there is a save file, check if its a new highscore
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)

		if file == null:
			print("Error opening file:")
			print(FileAccess.get_open_error())
			return

		print("high score save file found")

		var oldSaveData = file.get_var()
		print("previous high score game data loaded")

		# if we got a new highest level, save current game data
		if score["wave"] > oldSaveData["wave"]:
			newHighScore = true

		# if we got the save level but more kills, save current game data
		elif score["wave"] == oldSaveData["wave"] and score["kills"] > oldSaveData["kills"]:
			newHighScore = true

	if newHighScore:
		# Save highscore data
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		
		if file == null:
			print("Error opening save file")
			print(FileAccess.get_open_error())
			return

		print("Saving highscore...")
		file.store_var(score)

func _on_bullet_fired():
	score["bullets_fired"] += 1
	print(score)

var previous_RID: RID

func _on_bullet_hit(bullet_RID):
	if previous_RID != bullet_RID or !previous_RID:
		print("BULLET HIT")
		score["bullets_hit"] += 1
		previous_RID = bullet_RID

		# Player gets 10 points for unique each bullet that hits
		Events.emit_signal("give_player_money", 10)

func _on_wave_started(wave_number: int):
	score["wave"] = wave_number

func _on_zombie_death(_zombie: CharacterBody2D):
	score["kills"] += 1

func _on_give_player_money(money: int):
	score["points"] += money

func get_score():
	return score
