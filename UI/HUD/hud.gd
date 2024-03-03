extends Control

@onready var player_money = $MarginContainer/VBoxContainer/Points
@onready var equipped = $MarginContainer/HBoxContainer/VBoxContainer/GunName
@onready var clip_count = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/BulletsInClip
@onready var reserve_count = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/BulletsInReserve
@onready var wave_number = $MarginContainer/VBoxContainer/Wave

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var perk_container: HBoxContainer = $MarginContainer/MarginContainer/PerkContainer

func _ready():
	set_as_top_level(true)

	Events.player_money_change.connect(_player_money_change)
	Events.wave_number_change.connect(_on_wave_number_change)
	Events.player_perks_change.connect(_player_perks_change)
	
	Events.player_equipped_clip_count_change.connect(_update_equipped_clip_count)
	Events.player_equipped_reserve_count_change.connect(_update_equipped_reserve_count)
	Events.player_equipped_change.connect(_on_weapon_manager_player_equipped_change)
	
	animation_player.play("start_game")

func _on_wave_number_change(wave: int):
	wave_number.text = str(wave)
	animation_player.play("wave_start")
	
func _update_equipped_clip_count(count: int):
	clip_count.text = str(count)

func _update_equipped_reserve_count(count: int):
	reserve_count.text = str(count)

func _player_money_change(money: int):
	player_money.text = str(money)

func _player_perks_change(perks: Array[String]):
	# Clear out current perks
	for node in perk_container.get_children():
		node.queue_free()
	
	for perk in perks:
		var texture_rect: TextureRect = TextureRect.new()
		texture_rect.texture = Globals.PERK_INDEX[perk].HUD_image
		perk_container.add_child(texture_rect)
	

func _on_weapon_manager_player_equipped_change(weapon_name: String, weapon_level: int, modifier: String):
	equipped.text = modifier + ' ' + weapon_name if modifier else  weapon_name
