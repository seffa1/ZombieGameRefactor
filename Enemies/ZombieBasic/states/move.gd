extends "res://Libraries/state.gd"

@onready var animation_player = $"../../AnimationPlayer"
@onready var zombie_groans = $"../../ZombieGroans-Audio"
@onready var groan_timer = $"../../GroanTimer"
@onready var distance_check_timer: Timer = $"../../DistanceCheckTimer"

@export var groan_interval = 5  # min seconds between random groans

var is_targeting_player = false
var previous_position: Vector2

func _ready():
	# Connect to player position signal and feed that to the pathfinding component
	Events.player_position_change.connect(_on_player_position_changed)

func enter():
	distance_check_timer.start()
	previous_position = owner.global_position


	is_targeting_player = true
	if randi_range(0, 1) == 1:
		animation_player.play("zombie_walk_basic")
	else:
		animation_player.play("zombie_walk_basic_2")
	groan_timer.start(groan_interval + randf_range(0, 10))

func _on_player_position_changed(player_position: Vector2):
	# We only consume this signal to update the pathfinding IF we are in this state
	if is_targeting_player:
		owner.pathfinding_component.update_target_position(player_position)

# Clean up the state. Reinitialize values like a timer
func exit():
	is_targeting_player = false
	groan_timer.stop()
	return

func update(delta):
	# Check if dead
	if owner.health_component.health == 0:
		emit_signal("finished", "die")
		return

	# Check if we should do a random groan
	if groan_timer.is_stopped():
		zombie_groans.play_long()
		groan_timer.start(groan_interval + randf_range(0, 10))

	# Check if theres a player to attack
	if owner.player_detector.has_overlapping_areas():
		emit_signal("finished", "attack_player")
		return
		
	# Track the distance we travel to make sure we arent getting stuck
	if distance_check_timer.is_stopped():
		var distance_traveled = (owner.global_position - previous_position).length()
		if distance_traveled <= 50:
			print("DESPAWNING")
			owner.despawn()
		else:
			previous_position = owner.global_position
			distance_check_timer.start()

	# Move - velocity should be getting updated by the pathfinding component
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func _on_animation_finished(anim_name):
	return

