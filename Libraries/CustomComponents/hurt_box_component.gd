extends Area2D

"""
Detects collisions with a body that can hurt us and triggers:
	health_component: take damage
	giver_component: give money to the player
	bullet_impact_scene: spawn a self-queueing bullet impact
	status_reciever_component: applys status' if the body has them
"""

@export var health_component: Node2D
@export var bullet_impact_scene: PackedScene
@export var status_reciever: Node2D

@onready var gore_vfx = $"../GoreVFX"

func _on_area_entered(area: Area2D):
	""" 
	The area here is a hitbox component which should contain all the
	information we need to take damage, do knockbacks, trigger effects, etc.
	"""
	# Player gets 10 points for each bullet that hits
	Events.emit_signal("give_player_money", 10)
	
	# Take damage
	health_component.health -= area.damage
	
	# gore system tracks the last position a bullet / grenade / etc. did damage to it
	# so when the zombie dies, it knows the position of the thing that killed it
	# so we can spawn VFX items in the correct position (moving away from that position)
	gore_vfx.last_damage_position = area.position
	
	if area.hit_box_type == 0:  # impact
		gore_vfx.bullet_impact(area.owner.velocity)

