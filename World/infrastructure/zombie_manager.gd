extends Node2D


"""
Responsible for controlling and tracking the waves of zombies spawning.
"""

# Nodes
@onready var round_start_spawn_delay: Timer = $RoundStartSpawnDelay
@onready var zombie_container: Node = $ZombieContainer

# Variables
@export var spawn_delay_interval: float = 5  # seconds between each round of wave spawning
@export var MAX_ZOMBIES_ON_MAP: int = 30
@export_enum("the_labs", "test_chamber") var wave_spawn_type: String

# How many enemies per wave
# TODO - replace with a curve or equation
const TEST_CHAMBER_ZOMBIE_COUNT_PER_WAVE = {
	1: 1,
	2: 1,
	3: 1,
	4: 1,
	5: 1,
	6: 1,
	7: 1,
	8: 1,
	9: 1,
	10: 1,
	11: 1,
	12: 1,
	13: 1
}

const THE_LABS_ZOMBIE_COUNT_PER_WAVE = {
	1: 4,
	2: 9,
	3: 12,
	4: 17,
	5: 20,
	6: 27,
	7: 32,
	8: 40
}

var WAVE_INDEX

var zombie_base_health = 150

var wave_number: int = 1:
	set(value):
		wave_number = value
		Events.emit_signal("wave_number_change", wave_number)
	get:
		return wave_number
var zombies_to_be_killed: int = 0:  # Total zombies that need to be killed to get to the next wave
	set(value):
		zombies_to_be_killed = value
		Events.emit_signal("zombies_to_kill_change", zombies_to_be_killed)
	get:
		return zombies_to_be_killed

# dict of {zombie_instance_id: zombie_reference} that are currently spawned in.
# sometimes a zombie death trigger will go off more than once, so we check 
# that that zombie's id is in this dictionary to be sure that its a valid signal
# so we arent messing up the tracking of zombies
var zombie_ids: Dictionary = {} 
var zombies_on_map: int = 0:  # current zombies spawned on the map
	set(value):
		zombies_on_map = value
		Events.emit_signal("zombies_on_map_change", zombies_on_map)
	get:
		return zombies_on_map
		
# Functions
func _ready():
	Events.zombie_death.connect(_on_zombie_death)
	Events.zombie_despawn.connect(_on_zombie_despawn)
	Events.emit_signal("wave_number_change", wave_number)
	if wave_spawn_type == "test_chamber":
		WAVE_INDEX = TEST_CHAMBER_ZOMBIE_COUNT_PER_WAVE
	elif wave_spawn_type == "the_labs":
		WAVE_INDEX = THE_LABS_ZOMBIE_COUNT_PER_WAVE
	
	# Start the wave, connect signals, initialize UI
	start_wave()

# Controlling the wave ------------------------------------
func start_wave():
	assert(WAVE_INDEX.keys().find(wave_number) != -1, "Wave Number not in global wave index")
	zombies_to_be_killed = WAVE_INDEX[wave_number]
	set_base_health()
	
func set_base_health():
	if wave_number < 10:
		zombie_base_health = 150 + ((wave_number - 1) * 100)

	else:
		zombie_base_health = zombie_base_health * 1.1
	print("Zombie base health set - " + str(zombie_base_health))

func end_wave():
	_kill_all_zombies()  # just to be extra sure
	wave_number += 1
	round_start_spawn_delay.start(spawn_delay_interval)
	
func _on_spawn_delay_timer_timeout():
	start_wave()

# Controlling the spawns ------------------------------------
func _process(_delta):
	"""
	Call on zombie spawners to spawn zombies
	"""
	var spawners_in_range = 0
	for spawner in _select_spawners():
		if !spawner.in_range_to_spawn():
			continue  # skip spawners that arent in range
		spawners_in_range += 1
		if zombies_to_be_killed == 0 or zombies_on_map >= MAX_ZOMBIES_ON_MAP or zombies_on_map >= zombies_to_be_killed: 
			return
		if spawner.spawn_timer.is_stopped() and spawner.spawner_active and spawner.in_range_to_spawn():
			zombies_on_map += 1
			var zombie_instance = spawner.spawn_zombie()
			zombie_container.add_child(zombie_instance)
			zombie_instance.set_max_health(zombie_base_health)
			zombie_ids[zombie_instance.get_instance_id()] = zombie_instance
	
	zombies_on_map = len(get_tree().get_nodes_in_group("Zombies"))  # This is just a safe-gaurd incase the counter gets in a bad state

	# If no spawners are in range to spawn a zombie but zombies need to be spawned, go through the spawn checks
	# again without checking for the spawner range
	if spawners_in_range == 0:
		for spawner in _select_spawners():
			if zombies_to_be_killed == 0 or zombies_on_map >= MAX_ZOMBIES_ON_MAP or zombies_on_map >= zombies_to_be_killed: 
				return
			if spawner.spawn_timer.is_stopped() and spawner.spawner_active:
				zombies_on_map += 1
				var zombie_instance = spawner.spawn_zombie()
				zombie_container.add_child(zombie_instance)
				zombie_instance.set_max_health(zombie_base_health)
				zombie_instance.fill_health()
				zombie_ids[zombie_instance.get_instance_id()] = zombie_instance

func _select_spawners():
	return get_tree().get_nodes_in_group("ZombieSpawners")

# Tracking zombies ------------------------------------
func _on_zombie_death(zombie: CharacterBody2D):
	var id = zombie.get_instance_id()
	if id in zombie_ids:
		zombie_ids.erase(id)
		zombies_to_be_killed -= 1
		zombies_on_map -= 1
		if zombies_to_be_killed == 0:
			end_wave()

func _on_zombie_despawn(zombie: CharacterBody2D):
	"""
	Zombies despawn if they get too far from the player or get stuck.
	These zombie dont count towards the zombies required to kill for the next
	wave to start.
	"""
	var id = zombie.get_instance_id()
	if id in zombie_ids:
		zombie_ids.erase(id)
		zombies_on_map -= 1
		
func _kill_all_zombies():
	for zombie in get_tree().get_nodes_in_group("Zombies"):
		zombie.queue_free()
	zombie_ids = {}
