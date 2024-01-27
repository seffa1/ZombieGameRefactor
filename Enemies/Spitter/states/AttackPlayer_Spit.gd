extends "res://Libraries/state.gd"

"""
If a zombie is outside and within reach of a window, do break window animation.
"""
@onready var spit_emission_point: Marker2D = $"../../SpitEmissionPosition"

var spit_scene: PackedScene = preload("res://VFX/poisenSpitAttack/SpitterAttack.tscn")


var is_targeting_player: bool = false

func _ready():
	# TODO - move this to the enter func, and disconnect in the exit function
	# TODO - do this for all instances in this and all enemies (if not consuming the signal, why waste bandwith getting it)
	# Connect to player position signal and feed that to the pathfinding component
	Events.player_position_change.connect(_on_player_position_changed)

# Initialize the state. E.g. change the animation
func enter():
	owner.animation_player.play("zombie_attack_spit")
	is_targeting_player = true

func _on_player_position_changed(player_position: Vector2):
	if is_targeting_player:
		owner.pathfinding_component.update_target_position(player_position)

# Clean up the state. Reinitialize values like a timer
func exit():
	owner.animation_player.stop()
	is_targeting_player = false

func update(delta):
	# movement
	owner.velocity_component.decelerate(delta)
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func shoot_spit():
	# Spawn spit
	var spit_object = spit_scene.instantiate()
	spit_object.global_position = owner.global_position
	spit_object.rotation = spit_emission_point.rotation
	spit_object.direction = Vector2(1,0).rotated(spit_emission_point.rotation)
	ObjectRegistry.register_effect(spit_object)
	
	# change state back to 'seek player'
	emit_signal("finished", "seek_player")

