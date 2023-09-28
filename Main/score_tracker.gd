extends Node

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
