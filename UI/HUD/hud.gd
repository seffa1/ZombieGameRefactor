extends Control

@onready var player_money = $MarginContainer/VBoxContainer/Points
@onready var equipped = $MarginContainer/HBoxContainer/VBoxContainer/GunName
@onready var clip_count = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/BulletsInClip
@onready var reserve_count = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/BulletsInReserve
@onready var wave_number = $MarginContainer/VBoxContainer/Wave


func _ready():
	set_as_top_level(true)

	Events.player_money_change.connect(_player_money_change)
	Events.wave_number_change.connect(_on_wave_number_change)
	
	Events.player_perks_change.connect(_player_perks_change)
	
	Events.player_equipped_clip_count_change.connect(_update_equipped_clip_count)
	Events.player_equipped_reserve_count_change.connect(_update_equipped_reserve_count)
	Events.player_equipped_change.connect(_on_weapon_manager_player_equipped_change)

func _on_wave_number_change(wave: int):
	wave_number.text = str(wave)
	
func _update_equipped_clip_count(count: int):
	clip_count.text = str(count)

func _update_equipped_reserve_count(count: int):
	reserve_count.text = str(count)

func _player_money_change(money: int):
	player_money.text = str(money)

func _player_perks_change(perks: Array[String]):
	return
# TODO
#	var perk_text = ""
#	for perk in perks:
#		perk_text += perk + ", "
#	player_perks.text = perk_text

func _on_weapon_manager_player_equipped_change(weapon_name: String):
	equipped.text = weapon_name
