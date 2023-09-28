extends Area2D

"""
Detects collisions with a body that can hurt us and triggers:
	health_component: take damage
	giver_component: give money to the player
	status_reciever_component: applys status' if the body has them
	gives the gore system the impact types and velocities it needs to spawn gore vfx
"""

@export var money_reward_bullet_hit: int = 10
@export var damage_multiplier: float = 1.0

@export var health_component: Node2D
@export var status_reciever: Node2D

@export var gore_vfx: Node2D
@export var zombie_groan_audio: Node

func _on_area_entered(area: Area2D):
	""" 
	The area here is a hitbox component which should contain all the
	information we need to take damage, do knockbacks, trigger effects, etc
	from bullets, explosions, or anything else we can take damage from.
	
	"""
	# Take damage
	health_component.health -= area.damage * damage_multiplier
	
	# gore system tracks the last position a bullet / grenade / etc. did damage to it
	# so when the zombie dies, it knows the position of the thing that killed it
	# so we can spawn VFX items in the correct position (moving away from that position)
	gore_vfx.last_damage_position = area.global_position
	
	# If the area is an impact (from a bullet)
	if area.hit_box_type == 0:
		bullet_impact_effect(area)
	
	# If the area is an exposion
	elif area.hit_box_type == 1:
		explosion_impact_effect(area)

func bullet_impact_effect(area: Area2D):
	"""
	Defined for each child class, determines what happens when struck by a bullet.
	
	The area here is a hitbox component which should contain all the
	information we need to take damage, do knockbacks, trigger effects, etc
	from bullets, explosions, or anything else we can take damage from.
	"""
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
