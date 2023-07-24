@tool
extends Panel

@onready var player_stamina = $Stamina
@onready var player_rotation = $Rotation
@onready var player_position = $Position
@onready var player_money = $Money
@onready var player_perks = $Perks

func _ready():
	set_as_top_level(true)

func _on_player_player_stamina_change(stamina: int):
	player_stamina.text = str(stamina)

func _on_player_player_rotation_change(rotation):
	player_rotation.text = str(rotation)

func _on_player_player_position_change(position):
	player_position.text = str(position)

func _on_player_player_money_change(money):
	player_money.text = str(money)
	
func _on_player_player_perks_change(perks: Array[String]):
	var perk_text = ""
	for perk in perks:
		perk_text += perk + ", "
	player_perks.text = perk_text
