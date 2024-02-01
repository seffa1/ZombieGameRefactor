extends Node2D

"""
All the checks for IF a spawner should spawn a zombie happens at the zombie manager level.
This class is a very simple zombie factory.
Once placed in the scene, drag the associated doors into the export 'trigger_doors'.
If any of these doors are opened, this spawner becomes active via an emitted signal.

The play has a spawner detector that detects the spawner's area 2D. The zombie manager checks
for collisions there to determine it a spawner should be on or not.
"""

@onready var spawn_timer: Timer = $SpawnTimer
@onready var player_spawn_detector = $Area2D

@export var spawn_interval: float = 1
@export var spitter_only: bool = false
@export var bomber_only: bool = false
@export var police_only: bool = false
@export var spawner_active: bool = true
@export var trigger_doors: Array[Area2D]

@onready var zombie_list = [
	preload("res://Enemies/Bomber/ZombieBomber.tscn"),
	preload("res://Enemies/ZombieBasic/ZombieBasic_02.tscn"),
	preload("res://Enemies/Spitter/ZombieSpitter.tscn"),
	preload("res://Enemies/PoliceMan/ZombiePolice.tscn")
]

var target_window: Area2D

func _ready():
	# Find the closet window to set spawned zombies towards
	var smallest_distance = INF
	for window in get_tree().get_nodes_in_group("Windows"):
		var distance = (global_position - window.global_position).length()
		if distance < smallest_distance:
			smallest_distance = distance
			target_window = window
	assert(target_window != null, "There are no windows for spawner to target.")
	assert(spawner_active or len(trigger_doors) > 0, "An inactive spawner has no triggers doors to activate it!")
	
	if len(trigger_doors) > 0:
		for door in trigger_doors:
			door.door_opened.connect(_on_trigger_door_opened)

func _on_trigger_door_opened():
	spawner_active = true

func spawn_zombie() -> CharacterBody2D:
	# Creates the zombie and sets its needed properties
	var zombie_to_spawn = get_random_zombie()
	var zombie_instance = zombie_to_spawn.instantiate()
	zombie_instance.target_window = target_window
	zombie_instance.global_position = global_position
	
	# Timer is checked by the spawn manager before calling this function
	spawn_timer.start(spawn_interval)
	return zombie_instance

func get_random_zombie():
	if bomber_only:
		return zombie_list[0]
	if spitter_only:
		return zombie_list[2]
	if police_only:
		return zombie_list[3]
	
	var zombie_list_index = randi_range(0, 2)
	return zombie_list[zombie_list_index]

func in_range_to_spawn() -> bool:
	return player_spawn_detector.has_overlapping_areas()
	
func call_timer():
	spawn_timer.start(spawn_interval)
