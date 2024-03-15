extends "res://Libraries/state.gd"

@onready var velocity_component: Node = %VelocityComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var is_targeting_player = false
var previous_position: Vector2

func _ready():
	# Connect to player position signal and feed that to the pathfinding component
	Events.player_position_change.connect(_on_player_position_changed)

func _on_player_position_changed(player_position: Vector2):
	# We only consume this signal to update the pathfinding IF we are in this state
	if is_targeting_player:
		owner.pathfinding_component.update_target_position(player_position)

func enter():
	is_targeting_player = true
	animation_player.play("flame_attack")
	owner.set_walk_speed(250)

# Clean up the state. Reinitialize values like a timer
func exit():
	previous_position = owner.global_position
	is_targeting_player = false
	owner.reset_walk_speed()

func update(delta):
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func _on_attack_animation_complete():
	emit_signal("finished", "seek_player")
