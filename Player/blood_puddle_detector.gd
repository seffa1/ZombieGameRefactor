extends Area2D

@onready var footstep_timer: Timer = $BloodyFootstepTimer
@onready var footprint = preload("res://Player/Footprint.tscn")
@onready var leg_control = $"../LegControl"

var moving_footstep_interval: float = 0.3  # seconds between footsteps when moving (walking)
var sprinting_footstep_interval: float = 0.15  # seconds between footsteps when sprinting

var is_bloody: bool = false  # tracks if were are emitting bloody tracks or not
var steps_emitted: int = 0  # How many bloody tracks we've emitted since stepping in a blood puddle
var max_steps_to_emit: int = 10  # how many tracks we'll be left each time we step in a puddle
var is_left_foot: bool = true  # flag to determine which foot is emitting - effects the placement of the bloody footstep

var player_state: String = "idle"

# Track play state to see how often a track gets emitted
func _ready():
	Events.player_idle.connect(_player_idle)
	Events.player_moving.connect(_player_moving)
	Events.player_sprinting.connect(_player_sprinting)

func _player_idle():
	player_state = "idle"

func _player_moving():
	player_state = "moving"

func _player_sprinting():
	player_state = "sprinting"

# Control when tracks are emitted
func _on_area_entered(area):
	is_bloody = true
	footstep_timer.start(moving_footstep_interval)  # Start with a delay so the first step doesnt look like it happened before we stepped in the puddle
	steps_emitted = 0

func _process(delta):
	if !is_bloody or player_state == 'idle':
		return

	if footstep_timer.is_stopped():
		# Emit bloody footstep
		steps_emitted += 1

		var footstep_position: Vector2
		if is_left_foot:
			footstep_position = Vector2(0, -20)
		else:
			footstep_position = Vector2(0, 20)

		# Toggle the next footstep
		is_left_foot = !is_left_foot

		var instance = footprint.instantiate()
		instance.global_position = to_global(footstep_position)
		instance.global_rotation = leg_control.global_rotation
		ObjectRegistry.register_effect(instance)

		# Start interval
		match player_state:
			"moving":
				footstep_timer.start(moving_footstep_interval)
			"sprinting":
				footstep_timer.start(sprinting_footstep_interval)

	# Check if we've run out of blood on our feet
	if steps_emitted >= max_steps_to_emit:
		steps_emitted = 0
		is_bloody = false


