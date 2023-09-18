extends "res://Libraries/CustomComponents/hurt_box_component.gd"

@onready var right_hand_polygon: Polygon2D = $"../../../../Polygons/HandRight"
@onready var right_arm_lower: Polygon2D = $"../../../../Polygons/ArmRightLower"
@onready var right_upper_polygon: Polygon2D = $"../../../../Polygons/ArmRightUpper"
@onready var right_lower_hitbox: Area2D = $"../armRightLower/HurtBox-RightLower"
@onready var right_lower_collision: CollisionShape2D = $"../armRightLower/HurtBox-RightLower/CollisionShape2D"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var is_dead: bool = false

func bullet_impact_effect(area: Area2D):
	"""
	Defined for each child class, determines what happens when struck by a bullet.
	
	The area here is a hitbox component which should contain all the
	information we need to take damage, do knockbacks, trigger effects, etc
	from bullets, explosions, or anything else we can take damage from.
	"""
	if is_dead:
		return

	# Spawn bullet impact
	gore_vfx.bullet_impact(area.owner.velocity)
	
	# Apply knock back
	var knock_back = area.bullet_knockback
	var knock_back_vector = area.owner.velocity.normalized() * knock_back
	owner.velocity_component.impulse_in_direction(knock_back_vector)
	owner.velocity = owner.velocity_component.velocity
	
	# 10% Chance to play a hurt sound
	if randf_range(0, 100) > 90:
		zombie_groan_audio.play_short()
	
	# TODO - head shot VFX and special animation
	if health_component.health <= 0:
		death_effect()
		# TODO - spawn a lower arm/hand body part on ground

func explosion_impact_effect(area: Area2D):
	"""
	Defined for each child class, determines what happens when struck by an explosion.
	
	The area here is a hitbox component which should contain all the
	information we need to take damage, do knockbacks, trigger effects, etc
	from bullets, explosions, or anything else we can take damage from.
	"""
	if is_dead:
		return

	# Apply knock back
	var knock_back = area.bullet_knockback
	var knock_back_vector = (area.global_position - global_position).normalized() * knock_back
	owner.velocity_component.impulse_in_direction(knock_back_vector)
	owner.velocity = owner.velocity_component.velocity
	
	# Spawn blood vfx
	gore_vfx.play_splatter()
	gore_vfx.bullet_impact(knock_back_vector)
	
	# If an explosion kills, then send body parts flying and instantly remove the zombie with no death animation
	if health_component.health <= 0:
		death_effect()
		# TODO - spawn a lower arm/hand body part on ground and send it flying

func death_effect():
	# TODO - spawn a decaying blood particle vfx
	is_dead = true
	gore_vfx.play_splatter()

	# Disable Upper
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	collision_shape.disabled = true
	right_upper_polygon.hide()
	
	# Disable Lower
	right_lower_hitbox.set_deferred("monitorable", false)
	right_lower_hitbox.set_deferred("monitoring", false)
	right_lower_collision.disabled = true
	right_hand_polygon.hide()
	right_arm_lower.hide()
