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
@onready var spawn_area: CollisionShape2D = $SpawnArea/CollisionShape2D

@export var spawn_interval: float = 3
@export var spitter_only: bool = false
@export var bomber_only: bool = false
@export var spawner_active: bool = true
@export var trigger_doors: Array[Area2D]

@onready var zombie_list = [
	preload("res://Enemies/ZombieBasic/ZombieBasic_02.tscn"),
	preload("res://Enemies/Spitter/ZombieSpitter.tscn"),
	preload("res://Enemies/Bomber/ZombieBomber.tscn"),
]

var target_window: Area2D

func _ready():
	if len(trigger_doors) > 0:
		for door in trigger_doors:
			door.door_opened.connect(_on_trigger_door_opened)
	
	assert(spawn_area != null, 'You forgot to add a collision shape to an interior spawner')

func _on_trigger_door_opened():
	spawner_active = true
	
func get_interior_position():
	var rect: Rect2 = spawn_area.get_shape().get_rect()
	var chosen_x = rect.position.x + randi_range(0, abs(rect.size.x))
	var chose_y = rect.position.y + randi_range(0, abs(rect.size.y))
	return global_position + Vector2(chosen_x, chose_y)

func spawn_zombie(wave_number: int) -> CharacterBody2D:
	# Creates the zombie and sets its needed properties
	var zombie_to_spawn = get_random_zombie()
	var zombie_instance = zombie_to_spawn.instantiate()
	zombie_instance.target_window = target_window
	zombie_instance.global_position = get_interior_position()
	
	# Timer is checked by the spawn manager before calling this function
	spawn_timer.start(spawn_interval)
	return zombie_instance

func get_random_zombie():
	if spitter_only:
		return zombie_list[1]
	if bomber_only:
		return zombie_list[2]
	var zombie_list_index = randi_range(0, 2)
	return zombie_list[zombie_list_index]

func in_range_to_spawn() -> bool:
	return player_spawn_detector.has_overlapping_areas()
	
func call_timer():
	spawn_timer.start(spawn_interval)
