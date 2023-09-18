extends "res://Libraries/CustomComponents/hurt_box_component.gd"

@onready var head_polygon: Polygon2D = $"../../../../Polygons/Head"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var is_dead: bool = false

signal headless_death

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
	
	if health_component.health <= 0:
		# TODO - spawn blood particle emitter on head
		death_effect()

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
		gore_vfx.explosion_death(global_position, area.global_position)
		# TODO - spawn a head body part and send it flying
		Events.emit_signal("zombie_death", owner)
		owner.queue_free()

func death_effect():
	is_dead = true
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	collision_shape.set_deferred("disabled", true)
	head_polygon.hide()
	gore_vfx.play_splatter()
	# Transition states
	emit_signal("headless_death")
