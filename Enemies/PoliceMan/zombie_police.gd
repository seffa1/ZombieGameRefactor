extends CharacterBody2D

"""
This should be a lightweight script which glues the different components together.

NOTE: Make sure to add the zombie to the zombie group.
"""

# Components that need to be added to the rotation function
@onready var sprite: Sprite2D = $placeholderSprite
@onready var window_detector: Area2D = $WindowDetector
@onready var window_hit_box: Area2D = $WindowHitbox
@onready var player_detector: Area2D = $PlayerDetector
@onready var player_hit_box: Area2D = $PlayerHitbox
@onready var trigger_detector: Area2D = $TriggerDetector
@onready var skeleton_control: Node2D = $SkeletonControl
@onready var head_blood_emitter: CPUParticles2D = %HeadBloodEmitter
@onready var grenade_throw_detectors: Node2D = %GrenadeThrowDetectors
@onready var grenade_position: Node2D = $RotationController

# Helper Nodes
@onready var pathfinding_component: Node2D = $PathfindingComponent
@onready var velocity_component: Node = $VelocityComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: Node = $ZombieStateMachine

# Health Nodes
@onready var head_health: Node2D = $"HealthComponents/HealthComponent - Head"
@onready var left_upper_health: Node2D = $"HealthComponents/HealthComponent - LeftUpper"
@onready var left_lower_health: Node2D = $"HealthComponents/HealthComponent - LeftLower"
@onready var right_upper_health: Node2D = $"HealthComponents/HealthComponent - RightUpper"
@onready var right_lower_health: Node2D = $"HealthComponents/HealthComponent - RightLower"

@onready var modification_stack = preload("res://Enemies/Spitter/ZombieSpitter_ModificationStack.tres")

var ZOMBIE_DESPAWN_DISTANCE = 4000  # if a zombie gets this far from the player, despawn them

var target_window: Area2D # set by zombie spawner, used by state machine to get zombie through the target window

func _ready():
	# We must load the modification stack AFTER the zombie is a part of the scene tree or it breaks
	# We must also duplicate the modification resource or it gets shared between all the zombies (weird but whatever)
	$SkeletonControl/Skeleton.set_modification_stack(modification_stack.duplicate())
	$SkeletonControl/Skeleton.get_modification_stack().enabled = true
	Events.player_position_change.connect(_on_player_position_changed)
	setWalkingSpeed()

func setWalkingSpeed():
	randomize()
	var number = randi_range(-30, 50)
	velocity_component.max_velocity += number

func set_max_health(zombie_base_health: int):
	"""
	Called by zombie spawner on spawn.
	
	Zombies start with 150 health
	Zombies health increases by 100 each round until they hit 950 (Round 9)
	After this, zombie health follows this formula: health = health x 1.1
	"""
	head_health.max_health = zombie_base_health * .5
	head_health.fill_health()
	left_upper_health.max_health = zombie_base_health * 1.5
	left_upper_health.fill_health()
	right_upper_health.max_health = zombie_base_health * 1.5
	right_upper_health.fill_health()
	left_lower_health.max_health = zombie_base_health
	left_lower_health.fill_health()
	right_lower_health.max_health = zombie_base_health * .5
	right_lower_health.fill_health()

func _on_player_position_changed(player_position: Vector2):
	check_despawn(player_position)

func check_despawn(player_position: Vector2):
	"""
	Check if the player got too far from the zombie, then despawn the zombie.
	"""
	if (player_position - global_position).length() >= ZOMBIE_DESPAWN_DISTANCE:
		despawn()

func despawn():
	"""
	Called also by the move state if a zombie gets stuck.
	"""
	Events.emit_signal("zombie_despawn", self)
	queue_free()

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
	window_detector.rotation = lerp_angle(window_detector.rotation, angle, STEER_FORCE) 
	window_hit_box.rotation = lerp_angle(window_hit_box.rotation, angle, STEER_FORCE)
	player_detector.rotation = lerp_angle(player_detector.rotation, angle, STEER_FORCE)
	player_hit_box.rotation = lerp_angle(player_hit_box.rotation, angle, STEER_FORCE)
	trigger_detector.rotation = lerp_angle(trigger_detector.rotation, angle, STEER_FORCE)
	skeleton_control.rotation = lerp_angle(skeleton_control.rotation, angle, STEER_FORCE)
	head_blood_emitter.rotation = lerp_angle(head_blood_emitter.rotation, angle, STEER_FORCE)
	grenade_throw_detectors.rotation = lerp_angle(grenade_throw_detectors.rotation, angle - deg_to_rad(0), STEER_FORCE)
	grenade_position.rotation = lerp_angle(grenade_position.rotation, angle - deg_to_rad(0), STEER_FORCE)
