extends "res://Libraries/state.gd"

@onready var zombie_groans: Node2D = %ZombieGroans
@onready var health_component_left_arm: Node2D = %"HealthComponent - ArmLeft"
@onready var health_component_right_arm: Node2D = %"HealthComponent - ArmRight"

var is_targeting_player: bool = false

var left_arm_destroyed: bool = false
var right_arm_destroyed: bool = false

func _ready():
	# Connect to player position signal and feed that to the pathfinding component
	Events.player_position_change.connect(_on_player_position_changed)
	health_component_left_arm.health_at_zero.connect(_on_left_arm_destroyed)
	health_component_right_arm.health_at_zero.connect(_on_right_arm_destroyed)


func _on_left_arm_destroyed():
	left_arm_destroyed = true
func _on_right_arm_destroyed():
	right_arm_destroyed = true

# Initialize the state. E.g. change the animation
func enter():
	if !left_arm_destroyed and !right_arm_destroyed:
		owner.animation_player.play("zombie_attack_both_arms")
	elif left_arm_destroyed:
		owner.animation_player.play("zombie_attack_right_arm")
	else:
		owner.animation_player.play("zombie_attack_left_arm")

	zombie_groans.play_attack()
	is_targeting_player = true

func _on_player_position_changed(player_position: Vector2):
	if is_targeting_player:
		owner.pathfinding_component.update_target_position(player_position)

# Clean up the state. Reinitialize values like a timer
func exit():
	owner.animation_player.stop()
	is_targeting_player = false

func update(delta):
	# Keep moving towards player - velocity should be getting updated by the pathfinding component
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func _on_attack_animation_finished():
	emit_signal("finished", "seek_player")

