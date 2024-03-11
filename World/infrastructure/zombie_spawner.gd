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
@onready var overload_spawn_timer: Timer = %OverloadSpawnTimer

@export_category("zombie type debug")
@export var spitter_only: bool = false
@export var bomber_only: bool = false
@export var police_only: bool = false
@export var basic_zombie_only: bool = false
@export_category("Default Spawn Configurations")
## Where the zombie instance will be appending to the tree

@export var spawn_interval: float = 1
@export var spawner_active: bool = true
@export var trigger_doors: Array[Area2D]

@export_category("Overload Spawn Configurations")
@export var zombie_container: Node
@export var zombie_manager: Node
@export var is_overload_spawner: bool = false
@export var overload_vessel: Node2D
@export var overload_spawn_interval: int = 3

# dont re-arrange these
@onready var zombie_list = [
	preload("res://Enemies/Bomber/ZombieBomber.tscn"),
	preload("res://Enemies/ZombieBasic/ZombieBasic_02.tscn"),
	preload("res://Enemies/Spitter/ZombieSpitter.tscn"),
	preload("res://Enemies/PoliceMan/ZombiePolice.tscn")
]

var target_window: Area2D
var overload_activated: bool = false
var zombie_base_health = 150  # Gets adjustet each round

func _ready():
	# Find the closet window to set spawned zombies towards
	var smallest_distance = INF
	for window in get_tree().get_nodes_in_group("Windows"):
		var distance = (global_position - window.global_position).length()
		if distance < smallest_distance:
			smallest_distance = distance
			target_window = window
	assert(target_window != null, "There are no windows for spawner to target.")
	assert(spawner_active or len(trigger_doors) > 0 or is_overload_spawner, "An inactive spawner has no triggers doors to activate it!")
	assert(!is_overload_spawner or overload_vessel, 'Overload spawner not linked to a vessel')
	assert(!is_overload_spawner or zombie_container, "Overload Spawner not linked to container")
	assert(!is_overload_spawner or zombie_manager, "Overload Spawner not linked to manager")
	
	if len(trigger_doors) > 0:
		for door in trigger_doors:
			door.door_opened.connect(_on_trigger_door_opened)
	
	if is_overload_spawner:
		overload_vessel.overload_started.connect(_on_overload_started)
		overload_vessel.overload_ended.connect(_on_overload_ended)


# OVERLOAD BEHAVRIOR
func _on_overload_started():
	overload_activated = true
	spawn_zombie(Globals.wave_number)
	overload_spawn_timer.start(overload_spawn_interval)

func _on_overload_spawn_timer_timeout():
	if overload_activated:
		spawn_zombie(Globals.wave_number)
		overload_spawn_timer.start(overload_spawn_interval)

func _on_overload_ended():
	overload_activated = false
	overload_spawn_timer.stop()

func _on_trigger_door_opened():
	spawner_active = true

func spawn_zombie(wave_number: int) -> void:
	# Creates the zombie and sets its needed properties
	var zombie_to_spawn = get_random_zombie(wave_number)
	var zombie_instance = zombie_to_spawn.instantiate()
	zombie_instance.target_window = target_window
	zombie_instance.global_position = global_position
	
	if is_overload_spawner:
		zombie_instance.is_overload_zombie = true
	
	zombie_container.add_child(zombie_instance)
	zombie_instance.set_max_health(zombie_manager.zombie_base_health)

func get_zombie(wave_number: int) -> CharacterBody2D:
	
	# Creates the zombie and sets its needed properties
	var zombie_to_spawn = get_random_zombie(wave_number)
	var zombie_instance = zombie_to_spawn.instantiate()
	zombie_instance.target_window = target_window
	zombie_instance.global_position = global_position
	
	if is_overload_spawner:
		zombie_instance.is_overload_zombie = true
	
	# Timer is checked by the spawn manager before calling this function
	spawn_timer.start(spawn_interval)
	return zombie_instance

func get_random_zombie(wave_number: int):
	# Debug options
	if bomber_only:
		return zombie_list[0]
	if spitter_only:
		return zombie_list[2]
	if police_only:
		return zombie_list[3]
	if basic_zombie_only:
		return zombie_list[1]

	# Select rando zombie
	var chosen_zombie_index = 1 # basic zombie by default
	
	var police_spawn_chance = clampf(1 * wave_number, 0, 10)  # 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	if police_spawn_chance > randf_range(0, 100):
		chosen_zombie_index = 3
	
	var spitter_spawn_chance = clampf(2 * wave_number, 0, 25)  # 2, 4, 6, 8, 10, 12, 14, 16, 18, 20
	if spitter_spawn_chance > randf_range(0, 100):
		chosen_zombie_index = 2

	return zombie_list[chosen_zombie_index]

func in_range_to_spawn() -> bool:
	return player_spawn_detector.has_overlapping_areas()
	
func call_timer():
	spawn_timer.start(spawn_interval)



