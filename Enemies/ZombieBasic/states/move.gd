extends "res://Libraries/state.gd"


@export var WALK_SPEED_FOWARD: int = 300
@onready var animation_player = $"../../AnimationPlayer"

func _ready():
	# Connect to player position signal and feed that to the pathfinding component
	Events.player_position_change.connect(_on_player_position_changed)

func enter():
	animation_player.play("zombie_walk_basic")

func _on_player_position_changed(player_position: Vector2):
	owner.pathfinding_component.update_target_position(player_position)

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func update(delta):
	# Check if dead
	if owner.health_component.health == 0:
		emit_signal("finished", "die")
		return

	# Check if theres a player to attack
	elif owner.player_detector.has_overlapping_areas():
		emit_signal("finished", "attack_player")
		return

	# Move - velocity should be getting updated by the pathfinding component
	owner.velocity = owner.velocity_component.velocity.normalized() * WALK_SPEED_FOWARD
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func _on_animation_finished(anim_name):
	return

