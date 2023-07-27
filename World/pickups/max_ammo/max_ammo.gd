extends "res://World/pickups/pickup.gd"


func _trigger_pickup_effect(player: CharacterBody2D):
	"""
	Must be defined for all children classes. 
	See _on_player_detector_body_entered for more information
	on what this should do.
	"""
	# Refill all the ammo in all the player's weapons (even the ones not equipped)
	player.weapon_manager.max_ammo()

