extends "res://Libraries/CustomComponents/hurt_box_component.gd"

func bullet_impact_effect(area: Area2D):
	"""
	Defined for each child class, determines what happens when struck by a bullet.
	
	The area here is a hitbox component which should contain all the
	information we need to take damage, do knockbacks, trigger effects, etc
	from bullets, explosions, or anything else we can take damage from.
	"""
	print("Right Upper Bullet hit!")
	
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
		zombie_groan_audio.play_death()
		gore_vfx.play_splatter()

func explosion_impact_effect(area: Area2D):
	"""
	Defined for each child class, determines what happens when struck by an explosion.
	
	The area here is a hitbox component which should contain all the
	information we need to take damage, do knockbacks, trigger effects, etc
	from bullets, explosions, or anything else we can take damage from.
	"""
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
		Events.emit_signal("zombie_death", owner)
		owner.queue_free()
