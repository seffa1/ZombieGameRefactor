extends Node2D

"""
Path finding logic which updates the velocity component each tick to go towards
the target position (A*), and then calculates any avoidance (context-based-steering). 
The target position is supplied by the owner.
"""

@export var velocity_component: Node
@export var path_update_interval: float = 1

@onready var path_update_timer: Timer = $updatePathTimer
@onready var nagivation_agent: NavigationAgent2D = $NavigationAgent2D

var movement_direction

func update_target_position(position: Vector2):
	"""
	Each time the player's position changes, a signal goes out. The owner of this
	pathfinding component calls this each time is consumes the signal. An interval
	is used for performance/debugging reasons
	"""
	if path_update_timer.is_stopped():
		path_update_timer.start(path_update_interval)
		nagivation_agent.target_position = position

func _physics_process(delta):
	if nagivation_agent.is_navigation_finished():
		return
	
	movement_direction = to_local(nagivation_agent.get_next_path_position()).normalized()
	velocity_component.accelerate_in_direction(movement_direction)
