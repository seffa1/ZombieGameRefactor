extends Area2D

"""
All the information which needs to be given to the body which is shot is contained here.
When the hitbox is detected by a hurtbox, that hurt box can get all the information
it needs here to do different things it needs to do based on the hitbox damage, velocity, etc.
"""

# Variables
@export var damage: int # set by the gun shooting the bullet typically
var shooter: CharacterBody2D  # reference back to the player

func _on_area_entered(area):
	# If the bullets hitbox hits an enemy hurtbox
	owner.die()