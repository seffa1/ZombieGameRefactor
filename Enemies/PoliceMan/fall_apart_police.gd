extends Node2D

# TODO - this should a million % be an export array, then i dont have to keep re-saving this
# script for each enemy type
@onready var body_parts_forwards = [
	$"BodyPart-TorsoUpperTopDown", 
	$"BodyPart-Hand", 
	$"BodyPart-Hand2", 
	$"BodyPart-ArmLowerLeft", 
	$"BodyPart-ArmLowerLeft2", 
	$"BodyPart-ArmUpperLeft", 
	$"BodyPart-ArmUpperLeft2"
]

@export var item_ejection_speed: float = 90.0  # impulse multiplier applied to item on ejection
@export var item_ejection_speed_variance: float = .6  # percentage
@export var item_ejection_angle_variance: float = .2  # random direction applied to item on ejection
@export var item_rotation_variance: float = 0  # change the rotation of the spawn item in radians
@export var item_ejection_torque: float = 10000  # angular momentum applied to item on ejection
@export var item_ejection_torque_variance: float = 5000

func _ready():
	fall_apart()

func fall_apart():
	for part in body_parts_forwards:
		var impulse_speed = item_ejection_speed + (item_ejection_speed * randf_range(-item_ejection_speed_variance, item_ejection_speed_variance))
		var impulse_direction = rotation + randf_range(-item_ejection_angle_variance, item_ejection_angle_variance)
		var impulse_vector = Vector2.RIGHT.rotated(impulse_direction) * impulse_speed

		part.apply_impulse(impulse_vector)
		part.apply_torque(item_ejection_torque + randf_range(-item_ejection_torque_variance, item_ejection_torque_variance))
	

