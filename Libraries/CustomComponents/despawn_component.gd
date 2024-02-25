extends Node

@export_group('Configuration')
@export var state_machine: Node
@export var states_to_check: Array[Node]
@export var time_until_despawn: float = 5.0
@export var max_distance_considered: float = 50.0
## Should be true if the starting state needs to check despawn
@export var check_despawn: bool = true

@onready var distance_timer: Timer = %DistanceCheckTimer

var previous_position: Vector2

func _ready():
	state_machine.state_changed.connect(_on_state_changed)
	
func _on_state_changed(statestack):
	if statestack[0] in states_to_check:
		check_despawn = true
	else:
		check_despawn = false

func _process(delta):
	if !check_despawn:
		return

	# Track the distance we travel to make sure we arent getting stuck
	if distance_timer.is_stopped():
		var distance_traveled = (owner.global_position - previous_position).length()
		if distance_traveled <= max_distance_considered:
			owner.despawn()
		else:
			previous_position = owner.global_position
			distance_timer.start(time_until_despawn)
	