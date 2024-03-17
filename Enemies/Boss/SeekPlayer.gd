extends "res://Libraries/state.gd"

@onready var animation_player = %AnimationPlayer
@onready var flame_timer: Timer = %FlameAttackTimer
@onready var spit_timer: Timer = %SpitAttackTimer
@onready var health_component_fire: Node2D = %"HealthComponent - Flame"
@onready var health_component_spit: Node2D = %"HealthComponent - Spit"
@onready var health_component_left_arm: Node2D = %"HealthComponent - ArmLeft"
@onready var health_component_right_arm: Node2D = %"HealthComponent - ArmRight"


var is_targeting_player = false
var previous_position: Vector2
var player_position: Vector2

var fire_arm_destroyed: bool = false
var spit_arm_destroyed: bool = false
var left_arm_destroyed: bool = false
var right_arm_destroyed: bool = false

func _ready():
	# Connect to player position signal and feed that to the pathfinding component
	Events.player_position_change.connect(_on_player_position_changed)
	health_component_fire.health_at_zero.connect(_on_fire_arm_destroyed)
	health_component_spit.health_at_zero.connect(_on_spit_arm_destroyed)
	health_component_left_arm.health_at_zero.connect(_on_left_arm_destroyed)
	health_component_right_arm.health_at_zero.connect(_on_right_arm_destroyed)

func _on_fire_arm_destroyed():
	fire_arm_destroyed = true
func _on_spit_arm_destroyed():
	spit_arm_destroyed = true
func _on_left_arm_destroyed():
	left_arm_destroyed = true
func _on_right_arm_destroyed():
	right_arm_destroyed = true

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
	if !fire_arm_destroyed and flame_timer.is_stopped():
		flame_timer.start(10.0)
		emit_signal("finished", "flame_attack")
		return

	if !spit_arm_destroyed and spit_timer.is_stopped():
		spit_timer.start(12.0)
		emit_signal("finished", "ranged_attack")
		return
	
	if !(left_arm_destroyed and right_arm_destroyed) and owner.player_detector.has_overlapping_areas():
		emit_signal("finished", "attack_player")
		return
		
	if left_arm_destroyed and right_arm_destroyed and fire_arm_destroyed and spit_arm_destroyed:
		emit_signal("finished", "roar")

	# Move - velocity should be getting updated by the pathfinding component
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func _on_animation_finished(anim_name):
	return

func is_player_far_away():
	return (self.player_position - owner.global_position).length() > 500
