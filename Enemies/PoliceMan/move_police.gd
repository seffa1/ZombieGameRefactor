extends "res://Libraries/state.gd"

@onready var animation_player = $"../../AnimationPlayer"
@onready var zombie_groans = $"../../ZombieGroans-Audio"
@onready var groan_timer = $"../../GroanTimer"
@onready var grenade_throw_detectors = %GrenadeThrowDetectors
@onready var spit_timer: Timer = $"../../SpitTimer"

@export var groan_interval = 5  # min seconds between random groans

var is_targeting_player = false

func _ready():
	# Connect to player position signal and feed that to the pathfinding component
	Events.player_position_change.connect(_on_player_position_changed)

func enter():	
	# Enable spit detectors
	for rayCast in grenade_throw_detectors.get_children():
		rayCast.enabled = true

	is_targeting_player = true
	if randi_range(0, 1) == 1:
		animation_player.play("zombie_walk_basic")
	else:
		animation_player.play("zombie_walk_basic_2")
	groan_timer.start(groan_interval + randf_range(0, 10))

func _on_player_position_changed(player_position: Vector2):
	# We only consume this signal to update the pathfinding IF we are in this state
	if is_targeting_player:
		owner.pathfinding_component.update_target_position(player_position)

# Clean up the state. Reinitialize values like a timer
func exit():
	is_targeting_player = false
	groan_timer.stop()
	
	# Disable spit detectors
	for rayCast in grenade_throw_detectors.get_children():
		rayCast.enabled = false

	return

func update(delta):
	# Check if we should do a random groan
	if groan_timer.is_stopped():
		zombie_groans.play_spitter()
		groan_timer.start(groan_interval + randf_range(0, 10))

	# Check if theres a player to melee attack
	if owner.player_detector.has_overlapping_areas():
		emit_signal("finished", "attack_player")
		return
		
	# Check if the player is in the spit detectors to do a spit attack
	if spit_timer.is_stopped():
		for rayCast in grenade_throw_detectors.get_children():
			if rayCast.is_colliding():
				# 10 second cooldown on spitting
				spit_timer.start(10)
				emit_signal("finished" , "throw_grenade")
				return

	# Move - velocity should be getting updated by the pathfinding component
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func _on_animation_finished(anim_name):
	return

