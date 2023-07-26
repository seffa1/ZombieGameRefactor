@tool
extends Panel

@onready var player_stamina = $Stamina
@onready var player_rotation = $Rotation
@onready var player_position = $Position
@onready var player_money = $Money
@onready var player_perks = $Perks
@onready var player_weapons = $Weapons
@onready var equipped = $Equipped

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

func _on_weapon_container_player_weapons_change(weapons: Array[String]):
	var weapons_text = ""
	for weapon in weapons:
		weapons_text += weapon + ", "
	player_weapons.text = weapons_text

func _on_weapon_container_player_equipped_change(weapon_name: String):
	equipped.text = weapon_name
