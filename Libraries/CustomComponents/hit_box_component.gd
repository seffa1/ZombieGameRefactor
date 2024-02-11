extends Area2D

"""
All the information which needs to be given to the body which is shot is contained here.
When the hitbox is detected by a hurtbox, that hurt box can get all the information
it needs here to do different things it needs to do based on the hitbox damage, velocity, etc.
"""

# Variables controlled by the gun shooting

# Either set by the gun shooting (bullets) or static value (grenades) via the bullets init function
@export var damage: int
@export var bullet_knockback: float
var shooter: CharacterBody2D  # reference back to the player
var random_id: int  # set by bullet, for tracking accuracy when a gun fires multiple bullets at the same time ( shotguns )

signal enemy_hit()

func _ready():
	shooter = Globals.player

func _on_area_entered(_area):
	# Track bullet
	Events.emit_signal("bullet_hit", get_rid(), random_id)
	emit_signal("enemy_hit")


