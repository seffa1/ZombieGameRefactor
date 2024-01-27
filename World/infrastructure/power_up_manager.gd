extends Node


@onready var max_ammo = preload("res://World/pickups/max_ammo/MaxAmmo.tscn")

var rounds_since_max_ammo = 0
var zombie_deaths_this_round = 0
var spawn_max_ammo_this_round = false
var zombies_to_kill_this_round = 0


func _ready():
	Events.zombie_death.connect(_on_zombie_death)
	Events.wave_started.connect(_on_wave_started)
	
func _on_zombie_death(zombie: CharacterBody2D):
	zombie_deaths_this_round += 1
	
	if spawn_max_ammo_this_round:
		# This gaurentees a max ammo spawns before the last zombie is killed
		var spawn_chance = ( float(zombie_deaths_this_round) /  float(zombies_to_kill_this_round)) 
		if spawn_chance > randi_range(0, .98):
			spawn_max_ammo(zombie.global_position)


func _on_wave_started(wave_number: int, zombies_to_be_killed: int):
	zombies_to_kill_this_round = zombies_to_be_killed
	zombie_deaths_this_round = 0
	rounds_since_max_ammo += 1
	
	if get_round_max_ammo_drop_chance(wave_number) > randf_range(0, 1):
		spawn_max_ammo_this_round = true


func get_round_max_ammo_drop_chance(wave_number) -> float:
	""" 
	Chance there will be a max ammo this round. 
	These are the constants to adjust if max ammo frequency needs to be adjusted.
	"""
	if wave_number < 30:
		return float(rounds_since_max_ammo) * 0.17
	else:
		return float(rounds_since_max_ammo) * 0.03

func spawn_max_ammo(global_position: Vector2):
	var instance = max_ammo.instantiate()
	instance.global_position = global_position
	ObjectRegistry.register_effect(instance)

	rounds_since_max_ammo = 0
	spawn_max_ammo_this_round = false
