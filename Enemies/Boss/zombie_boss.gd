extends CharacterBody2D

"""
This should be a lightweight script which glues the different components together.

NOTE: Make sure to add the zombie to the zombie group.
"""

# Components that need to be added to the rotation function
@onready var sprite: Sprite2D = $placeholderSprite
@onready var player_detector: Area2D = $PlayerDetector
@onready var player_hit_box: Area2D = $PlayerHitbox
@onready var skeleton_control: Node2D = %SkeletonControl
#@onready var spit_detectors: Node2D = %SpitDetector
#@onready var spit_emission_point: Marker2D = $SpitEmissionPosition
#@onready var conductable_component: Area2D = %ConductableComponent

# Helper Nodes
@onready var pathfinding_component: Node2D = $PathfindingComponent
@onready var velocity_component: Node = %VelocityComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: Node = $ZombieStateMachine

@onready var modification_stack = preload("res://Enemies/Boss/boss_skeleton_modification_stack_2d.tres")

var base_walking_speed: float = 190

func _ready():
	# We must load the modification stack AFTER the zombie is a part of the scene tree or it breaks
	# We must also duplicate the modification resource or it gets shared between all the zombies (weird but whatever)
	$SkeletonControl/Skeleton.set_modification_stack(modification_stack.duplicate())
	$SkeletonControl/Skeleton.get_modification_stack().enabled = true
	reset_walk_speed()

func set_walk_speed(speed: float):
	velocity_component.max_velocity = speed

func reset_walk_speed():
	velocity_component.max_velocity = base_walking_speed

func update_rotation():
	"""
	Called by the move state to update the rotation of the zombie.
	"""
	var STEER_FORCE = 0.1
	var angle = velocity_component.velocity.angle()
	
	# if the zombies velocity is in the opposite direction as the target position, instead
	# of rotating towards the velcity, rotate towards the target position.
	# This was put in because bullet knockbacks were causing zombies to turn towards
	# the direction they were getting pushed back and it looked bad.
	if velocity_component.velocity.normalized().dot(pathfinding_component.nagivation_agent.target_position.normalized()) < .2:
		angle = (pathfinding_component.nagivation_agent.target_position - global_position).angle()
	
	sprite.rotation = lerp_angle(sprite.rotation, angle - deg_to_rad(90), STEER_FORCE) 
	player_detector.rotation = lerp_angle(player_detector.rotation, angle, STEER_FORCE)
	player_hit_box.rotation = lerp_angle(player_hit_box.rotation, angle, STEER_FORCE)
	skeleton_control.rotation = lerp_angle(skeleton_control.rotation, angle, STEER_FORCE)
	# head_blood_emitter.rotation = lerp_angle(head_blood_emitter.rotation, angle, STEER_FORCE)
	# spit_detectors.rotation = lerp_angle(spit_detectors.rotation, angle - deg_to_rad(0), STEER_FORCE)
	# spit_emission_point.rotation = lerp_angle(spit_emission_point.rotation, angle - deg_to_rad(0), STEER_FORCE)
	# conductable_component.rotation = lerp_angle(conductable_component.rotation, angle - deg_to_rad(0), STEER_FORCE)
