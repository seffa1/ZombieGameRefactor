extends Area2D

"""
Detects collisions with a body that can hurt us and triggers:
	health_component: take damage
	giver_component: give money to the player
	bullet_impact_scene: spawn a self-queueing bullet impact
	status_reciever_component: applys status' if the body has them
"""

@export var health_component: Node2D
@export var giver_component: Node2D
@export var bullet_impact_scene: PackedScene
@export var status_reciever: Node2D


func _on_area_entered(area: Area2D):
	""" 
	The area here is a hitbox component which should contain all the
	information we need to take damage, do knockbacks, trigger effects, etc.
	"""
	print("OUCH")
	print(area.damage)
	print(area.shooter)
