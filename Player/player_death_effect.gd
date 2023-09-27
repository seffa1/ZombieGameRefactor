extends Node2D

@onready var body_parts_forwards = [
	$"Player-BodyPart-Head", 
	$"Player-BodyPart-LeftArm", 
	$"Player-BodyPart-LeftArm2", 
	$"Player-BodyPart-LeftArm3", 
	$"Player-BodyPart-RighLet", 
	$"Player-BodyPart-Torso"
]

@onready var animation_player = $AnimationPlayer
@onready var blood_splatter_scene = preload("res://VFX/Gore/blood_splatters/BloodSplatter.tscn")

@export var item_ejection_speed: float = 190.0  # impulse multiplier applied to item on ejection
@export var item_ejection_speed_variance: float = .9  # percentage
@export var item_ejection_angle_variance: float = .2  # random direction applied to item on ejection
@export var item_rotation_variance: float = 0  # change the rotation of the spawn item in radians
@export var item_ejection_torque: float = 100000  # angular momentum applied to item on ejection
@export var item_ejection_torque_variance: float = 50000

var direction_rotation = 0

func _ready():
	fall_apart()

func fall_apart():
	animation_player.play("death_effect")
	
	for part in body_parts_forwards:
		var impulse_speed = item_ejection_speed + (item_ejection_speed * randf_range(-item_ejection_speed_variance, item_ejection_speed_variance))

		var impulse_vector = Vector2.RIGHT.rotated(direction_rotation) * impulse_speed
		direction_rotation += deg_to_rad(60)

		part.apply_impulse(impulse_vector)
		part.apply_torque(item_ejection_torque + randf_range(-item_ejection_torque_variance, item_ejection_torque_variance))
	
		var blood_splatter = blood_splatter_scene.instantiate()
		blood_splatter.global_position = global_position
		ObjectRegistry.register_effect(blood_splatter)
		blood_splatter.apply_impulse(impulse_vector)
