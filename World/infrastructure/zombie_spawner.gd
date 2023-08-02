extends Node2D

signal zombie_spawned  # automatically connected to the zombie manager, in zombie manager _ready()

@onready var spawn_timer: Timer = $SpawnTimer
@export var spawn_interval: float = 1

@onready var zombie_list = [
	preload("res://Enemies/ZombieBasic/ZombieBasic_01.tscn")
]

func spawn_zombie():
	# Add the zombie as a child of the zombie manager and pass a refernce for tracking
	var zombie_to_spawn = get_random_zombie()
	var zombie_instance = zombie_to_spawn.instantiate()
	zombie_instance.global_position = global_position
	owner.add_child(zombie_instance)
	emit_signal("zombie_spawned", zombie_instance)
	
	# Timer is checked by the spawn manager before calling this function
	spawn_timer.start(spawn_interval)

func get_random_zombie():
	var zombie_list_index = randi_range(0, len(zombie_list) - 1)
	return zombie_list[zombie_list_index]
