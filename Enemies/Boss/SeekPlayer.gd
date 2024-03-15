extends "res://Libraries/state.gd"

@onready var animation_player = %AnimationPlayer
@onready var flame_timer: Timer = %FlameAttackTimer
@onready var spit_timer: Timer = %SpitAttackTimer

var is_targeting_player = false
var previous_position: Vector2

var player_position: Vector2

func _ready():
	# Connect to player position signal and feed that to the pathfinding component
	Events.player_position_change.connect(_on_player_position_changed)

func enter():
	previous_position = owner.global_position

	is_targeting_player = true
	animation_player.play("zombie_walk_basic")

func _on_player_position_changed(player_position: Vector2):
	# We only consume this signal to update the pathfinding IF we are in this state
	self.player_position = player_position
	if is_targeting_player:
		owner.pathfinding_component.update_target_position(player_position)

# Clean up the state. Reinitialize values like a timer
func exit():
	previous_position = owner.global_position
	is_targeting_player = false

func update(delta):
	# Check if theres a player to melee attack
	if owner.player_detector.has_overlapping_areas():
		emit_signal("finished", "attack_player")
		return

	if flame_timer.is_stopped():
		flame_timer.start(10.0)
		emit_signal("finished", "flame_attack")
		return

	if spit_timer.is_stopped():
		spit_timer.start(12.0)
		emit_signal("finished", "ranged_attack")
		return

	# Move - velocity should be getting updated by the pathfinding component
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func _on_animation_finished(anim_name):
	return

func is_player_far_away():
	return (self.player_position - owner.global_position).length() > 500
