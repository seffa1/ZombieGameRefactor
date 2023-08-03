extends Node2D

"""
All the checks for IF a spawner should spawn a zombie happens at the zombie manager level.
This class is a very simple zombie factory.
"""

@onready var spawn_timer: Timer = $SpawnTimer
@export var spawn_interval: float = 1
@export var spawner_active: bool = true

@onready var zombie_list = [
	preload("res://Enemies/ZombieBasic/ZombieBasic_01.tscn")
]

func spawn_zombie():
	# Add the zombie as a child of the zombie manager and pass a refernce for tracking
	var zombie_to_spawn = get_random_zombie()
	var zombie_instance = zombie_to_spawn.instantiate()
	zombie_instance.global_position = global_position
	
	# Timer is checked by the spawn manager before calling this function
	spawn_timer.start(spawn_interval)
	return zombie_instance

func get_random_zombie():
	var zombie_list_index = randi_range(0, len(zombie_list) - 1)
	return zombie_list[zombie_list_index]
