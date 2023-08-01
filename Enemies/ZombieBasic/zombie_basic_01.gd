extends CharacterBody2D

"""
This should be a lightweight script which glues the different components together.
"""

# Components that need to be rotated
@onready var sprite: Sprite2D = $placeholderSprite
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var window_detector: Area2D = $WindowDetector

# Healper nodes
@onready var rotational_component: Node2D = $RotationComponent
@onready var health_component: Node2D = $HealthComponent
@onready var pathfinding_component: Node2D = $PathfindingComponent
@onready var velocity_component: Node = $VelocityComponent

func _ready():
	Events.player_position_change.connect(_on_player_position_changed)

func _on_player_position_changed(player_position: Vector2):
	pathfinding_component.update_target_position(player_position)

func update_rotation():
	"""
	Called by the move state to update the rotation of the zombie.
	"""
	var STEER_FORCE = .1
	var angle = velocity_component.velocity.angle()
	
	sprite.rotation = lerp_angle(sprite.rotation, angle - deg_to_rad(90), STEER_FORCE) 
	hurt_box_component.rotation = lerp_angle(hurt_box_component.rotation, angle, STEER_FORCE) 
	window_detector.rotation = lerp_angle(window_detector.rotation, angle, STEER_FORCE) 
