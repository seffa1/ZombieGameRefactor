extends "res://VFX/self_freeing_component.gd"

@export var item_ejection_speed_variance: float = .3  # percentage
@export var item_ejection_angle_variance: float = 1  # random direction applied to item on ejection
@export var item_rotation_variance: float = 0  # change the rotation of the spawn item in radians
@export var item_ejection_torque: float = 100000  # angular momentum applied to item on ejection
@export var item_ejection_torque_variance: float = 50000

@onready var hit_box_component: Area2D = %HitBoxComponent

var _weapon_level
var _bullet_knockback

# Parameters passed in by the gun instantiating it
func init(bullet_damage: int, bullet_shooter: CharacterBody2D, bullet_knockback: float, weapon_level: int, random_id: int, is_penetrating_shot: bool=false):
	hit_box_component.damage = bullet_damage
	hit_box_component.shooter = bullet_shooter
	hit_box_component.random_id = random_id
	self._weapon_level = weapon_level
	self._bullet_knockback = bullet_knockback

func start(position, direction, speed):
	global_position = position
	rotation = direction.angle() - deg_to_rad(90)
	
	var impulse_speed = speed + (speed * randf_range(-item_ejection_speed_variance, item_ejection_speed_variance))
	var impulse_direction = rotation + randf_range(-item_ejection_angle_variance, item_ejection_angle_variance)
	var impulse_vector = Vector2.DOWN.rotated(impulse_direction) * impulse_speed

	apply_impulse(impulse_vector)
	apply_torque(item_ejection_torque + randf_range(-item_ejection_torque_variance, item_ejection_torque_variance))
	
	# Set knockback
	hit_box_component.knockback_vector = impulse_vector.normalized() * _bullet_knockback

