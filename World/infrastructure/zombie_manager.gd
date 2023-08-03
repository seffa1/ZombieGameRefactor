extends Node2D


"""
Responsible for controlling and tracking the waves of zombies spawning.
"""

# Nodes
@onready var round_start_spawn_delay: Timer = $RoundStartSpawnDelay
@onready var zombie_container: Node = $ZombieContainer

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
var zombies_on_map: int = 0:  # current zombies spawned on the map
	set(value):
		zombies_on_map = value
		Events.emit_signal("zombies_on_map_change", zombies_on_map)
	get:
		return zombies_on_map
		
# Functions
func _ready():
	# Start the wave, connect signals, initialize UI
	start_wave()
	Events.zombie_death.connect(_on_zombie_death)
	Events.emit_signal("wave_number_change", wave_number)

# Controlling the wave ------------------------------------
func start_wave():
	assert(Globals.WAVE_INDEX.keys().find(wave_number) != -1, "Wave Number not in global wave index")
	zombies_to_be_killed = Globals.WAVE_INDEX[wave_number]

func end_wave():
	_kill_all_zombies()  # just to be extra sure
	wave_number += 1
	round_start_spawn_delay.start(spawn_delay_interval)
	
func _on_spawn_delay_timer_timeout():
	start_wave()

# Controlling the spawns ------------------------------------
func _process(delta):
	"""
	Call on zombie spawners to spawn zombies
	"""
	for spawner in _select_spawners():
		if zombies_to_be_killed == 0 or zombies_on_map == MAX_ZOMBIES_ON_MAP or zombies_on_map == zombies_to_be_killed: 
			return
		if spawner.spawn_timer.is_stopped() and spawner.spawner_active:
			zombies_on_map += 1
			var zombie_instance = spawner.spawn_zombie()
			zombie_container.add_child(zombie_instance)
			zombie_ids[zombie_instance.get_instance_id()] = zombie_instance
	zombies_on_map = len(get_tree().get_nodes_in_group("Zombies"))  # This is just a safe-gaurd incase the counter gets in a bad state

func _select_spawners():
	# TODO - only select spawners close to the player, or in a room the player has opened
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
	
func _kill_all_zombies():
	for zombie in get_tree().get_nodes_in_group("Zombies"):
		zombie.queue_free()
	zombie_ids = {}
