extends "res://Libraries/state.gd"

@onready var animation_player = %AnimationPlayer

var is_targeting_player = false
var previous_position: Vector2
var player_position: Vector2

func _ready():
	# Connect to player position signal and feed that to the pathfinding component
	Events.player_position_change.connect(_on_player_position_changed)

func enter():
	previous_position = owner.global_position
	is_targeting_player = true
	animation_player.play("head_attack")

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
	# Move - velocity should be getting updated by the pathfinding component
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func _on_head_attack_animation_finished():
	emit_signal("finished", "charge_player")

