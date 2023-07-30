extends Area2D

"""
All the information which needs to be given to the body which is shot is contained here.
When the hitbox is detected by a hurtbox, that hurt box can get all the information
it needs here to do different things it needs to do based on the hitbox damage, velocity, etc.
"""

# Variables
var damage: int:
	get:
		return damage
	set(value):
		damage = value

var shooter: CharacterBody2D:  # reference back to the player
	get:
		return shooter
	set(value):
		shooter = value

func _on_area_entered(area):
	# If the bullets hitbox hits an enemy hurtbox
	owner.die()
