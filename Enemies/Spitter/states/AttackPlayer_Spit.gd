extends "res://Libraries/state.gd"

"""
If a zombie is outside and within reach of a window, do break window animation.
"""
@onready var spit_emission_point: Marker2D = $"../../SpitEmissionPosition"

var spit_scene: PackedScene = preload("res://VFX/poisenSpitAttack/SpitterAttack.tscn")

var player_position: Vector2

func _ready():
	# Connect to player position signal and feed that to the pathfinding component
	Events.player_position_change.connect(_on_player_position_changed)

# Initialize the state. E.g. change the animation
func enter():
	owner.animation_player.play("zombie_attack_spit")

func _on_player_position_changed(player_position: Vector2):
	player_position = player_position
	owner.pathfinding_component.update_target_position(player_position)

# Clean up the state. Reinitialize values like a timer
func exit():
	owner.animation_player.stop()

func update(delta):
	print(spit_emission_point.rotation)
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

