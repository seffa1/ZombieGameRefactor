@tool
extends Panel

@onready var player_stamina = $Stamina
@onready var player_rotation = $Rotation
@onready var player_position = $Position
@onready var player_money = $Money
@onready var player_perks = $Perks
@onready var player_weapons = $Weapons
@onready var equipped = $Equipped
@onready var clip_count = $ClipCount
@onready var reserve_count = $Reserve
@onready var direction = $Direction
@onready var wave_number = $WaveNumber
@onready var zombies_to_kill = $ZombiesToKill
@onready var zombies_on_map = $ZombiesOnMap

func _ready():
	set_as_top_level(true)
	
	Events.player_equipped_clip_count_change.connect(_update_equipped_clip_count)
	Events.player_equipped_reserve_count_change.connect(_update_equipped_reserve_count)
	
	Events.player_stamina_change.connect(_player_stamina_change)
	Events.player_direction_change.connect(_player_direction_change)
	Events.player_money_change.connect(_player_money_change)
	Events.player_rotation_change.connect(_player_rotation_change)
	Events.player_position_change.connect(_player_position_change)
	Events.player_perks_change.connect(_player_perks_change)
	
	Events.player_weapons_change.connect(_on_weapon_manager_player_weapons_change)
	Events.player_equipped_change.connect(_on_weapon_manager_player_equipped_change)
	
	Events.wave_number_change.connect(_on_wave_number_change)
	Events.zombies_to_kill_change.connect(_on_zombies_to_kill_change)
	Events.zombies_on_map_change.connect(_on_zombies_on_map_change)

func _on_zombies_on_map_change(quantity: int):
	zombies_on_map.text = str(quantity)

func _on_wave_number_change(wave: int):
	wave_number.text = str(wave)
	
func _on_zombies_to_kill_change(number: int):
	zombies_to_kill.text = str(number)
	
func _player_direction_change(direction_string: String):
	direction.text = direction_string

func _update_equipped_clip_count(count: int):
	clip_count.text = str(count)

func _update_equipped_reserve_count(count: int):
	reserve_count.text = str(count)

func _player_stamina_change(stamina: int):
	player_stamina.text = str(stamina)

func _player_money_change(money: int):
	player_money.text = str(money)

func _player_rotation_change(rotation):
	player_rotation.text = str(rotation)

func _player_position_change(position):
	player_position.text = str(position)
	
func _player_perks_change(perks: Array[String]):
	var perk_text = ""
	for perk in perks:
		perk_text += perk + ", "
	player_perks.text = perk_text

func _on_weapon_manager_player_weapons_change(weapons: Array[String]):
	var weapons_text = ""
	for weapon in weapons:
		weapons_text += weapon + ", "
	player_weapons.text = weapons_text

func _on_weapon_manager_player_equipped_change(weapon_name: String):
	equipped.text = weapon_name
