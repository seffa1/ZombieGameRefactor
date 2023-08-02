extends Node2D


"""
Responsible for controlling and tracking the waves of zombies spawning.
"""

# Nodes
@onready var spawn_delay_timer: Timer = $SpawnDelayTimer

# Variables
@export var spawn_delay_interval: float = 5
@export var MAX_ZOMBIES_ON_MAP: int = 30

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
var zombies_on_map: int = 0  # current zombies spawned on the map

# Functions
func _ready():
	# Connect all spawner signals
	for spawner in get_tree().get_nodes_in_group("ZombieSpawners"):
		spawner.zombie_spawned.connect("_on_zombie_spawner_zombie_spawned")

# Controlling the wave ------------------------------------
func start_wave():
	assert(Globals.WAVE_INDEX.keys().find(wave_number) != -1, "Wave Number not in global wave index")
	zombies_to_be_killed = Globals.WAVE_INDEX[wave_number]
	Events.emit_signal("wave_started", wave_number)

func end_wave():
	_kill_all_zombies()  # just to be extra sure
	wave_number += 1
	spawn_delay_timer.start(spawn_delay_interval)
	
func _on_spawn_delay_timer_timeout():
	start_wave()

# Tracking zombies ------------------------------------
func _on_zombie_spawner_zombie_spawned(zombie: CharacterBody2D):
	zombies_on_map += 1
	zombie_ids[zombie.get_instance_id()] = zombie

func _on_zombie_death(id):
	if id in zombie_ids:
		zombie_ids.erase(id)
		zombies_to_be_killed -= 1
		if zombies_to_be_killed == 0:
			end_wave()
	
func _kill_all_zombies():
	for zombie in get_tree().get_nodes_in_group("Zombies"):
		zombie.queue_free()

# Controlling the spawns ------------------------------------
func _process(delta):
	"""
	Call on zombie spawners to spawn zombies
	"""
	for spawner in _select_spawners():
		if zombies_to_be_killed == 0 or zombies_on_map == MAX_ZOMBIES_ON_MAP:
			return
		if spawner.spawn_timer.is_stopped():
			spawner.spawn_zombie()

func _select_spawners():
	# TODO - only select spawners close to the player, or in a room the player has opened
	return get_tree().get_nodes_in_group("ZombieSpawners")
