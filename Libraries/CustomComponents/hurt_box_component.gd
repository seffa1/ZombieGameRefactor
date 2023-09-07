extends Area2D

"""
Detects collisions with a body that can hurt us and triggers:
	health_component: take damage
	giver_component: give money to the player
	status_reciever_component: applys status' if the body has them
	gives the gore system the impact types and velocities it needs to spawn gore vfx
"""

@export var health_component: Node2D
@export var bullet_impact_scene: PackedScene
@export var status_reciever: Node2D

@onready var gore_vfx = $"../GoreVFX"

func _on_area_entered(area: Area2D):
	""" 
	The area here is a hitbox component which should contain all the
	information we need to take damage, do knockbacks, trigger effects, etc
	from bullets, explosions, or anything else we can take damage from.
	
	"""
	# Player gets 10 points for each bullet that hits
	Events.emit_signal("give_player_money", 10)
	
	# Take damage
	health_component.health -= area.damage
	
	# gore system tracks the last position a bullet / grenade / etc. did damage to it
	# so when the zombie dies, it knows the position of the thing that killed it
	# so we can spawn VFX items in the correct position (moving away from that position)
	gore_vfx.last_damage_position = area.global_position
	
	# If the area is an impact (from a bullet)
	if area.hit_box_type == 0:
		# Spawn bullet impact
		gore_vfx.bullet_impact(area.owner.velocity)
		
		# Apply knock back
		var knock_back = area.bullet_knockback
		var knock_back_vector = area.owner.velocity.normalized() * knock_back
		owner.velocity_component.impulse_in_direction(knock_back_vector)
		owner.velocity = owner.velocity_component.velocity
		
		# TODO - head shot VFX and special animation
		if health_component.health <= 0:
			gore_vfx.play_splatter()
	
	# If the area
	elif area.hit_box_type == 1:
		return

