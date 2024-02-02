extends "res://Libraries/state.gd"

"""
If a zombie is outside and within reach of a window, do break window animation.
"""

@onready var grenade_emission_point = $"../../RotationController/GrenadeEmissionPoint"
@onready var grenade_rotation_controller = $"../../RotationController"
var grenade_scene: PackedScene = preload("res://Enemies/PoliceMan/PoliceGrenade.tscn")


var is_targeting_player: bool = false

func _ready():
	# TODO - move this to the enter func, and disconnect in the exit function
	# TODO - do this for all instances in this and all enemies (if not consuming the signal, why waste bandwith getting it)
	# Connect to player position signal and feed that to the pathfinding component
	Events.player_position_change.connect(_on_player_position_changed)

# Initialize the state. E.g. change the animation
func enter():
	owner.animation_player.play("zombie_throw_grenade")
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

func throw_grenade():
	# Create a new instance and attach to the global registry
	var equipment_object = grenade_scene.instantiate()
	equipment_object.global_position = grenade_emission_point.global_position
	equipment_object.rotation = grenade_rotation_controller.rotation
	ObjectRegistry.register_effect(equipment_object)
	
	# Apply the impulse
	var distance_to_player = (Globals.player.global_position - owner.global_position).length()
	
	# The remap range determines how accuracte the distance the grenade goes to land on the player
	var charge_value = remap(distance_to_player, 0, 400, .1, 1.5)
	print(charge_value)
	var direction_vector = Vector2.RIGHT.rotated(grenade_rotation_controller.rotation) *  charge_value * 200
	equipment_object.apply_impulse(direction_vector)
	
	# Give it some random torque
	var item_ejection_torque: float = 20000  # angular momentum applied to item on ejection
	var item_ejection_torque_variance: float = 18000
	equipment_object.apply_torque(item_ejection_torque + randf_range(-item_ejection_torque_variance, item_ejection_torque_variance))
	
	# change state back to 'seek player'
	emit_signal("finished", "seek_player")

