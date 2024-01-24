extends "res://Libraries/state.gd"

@onready var zombie_groans = $"../../ZombieGroans-Audio"

var is_targeting_player = false

func _ready():
	# Connect to player position signal and feed that to the pathfinding component
	Events.player_position_change.connect(_on_player_position_changed)

# Initialize the state. E.g. change the animation
func enter():
	owner.animation_player.play("zombie_attack_basic")
	zombie_groans.play_attack()

func _on_player_position_changed(player_position: Vector2):
	# We only consume this signal to update the pathfinding IF we are in this state
	if is_targeting_player:
		owner.pathfinding_component.update_target_position(player_position)

# Clean up the state. Reinitialize values like a timer
func exit():
	owner.animation_player.stop()

func update(delta):
	# Move - velocity should be getting updated by the pathfinding component
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()
	
	# Check if player not in reach anymore
	if !owner.player_detector.has_overlapping_areas():
		emit_signal("finished", "seek_player")
		return

