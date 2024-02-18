extends Area2D

"""
All the information which needs to be given to the body which is shot is contained here.
When the hitbox is detected by a hurtbox, that hurt box can get all the information
it needs here to do different things it needs to do based on the hitbox damage, velocity, etc.
"""

signal enemy_hit()

## Optional argument, checked by components of the hurt box, to determine which impact VFXs to play
@export_enum("bullet", "explosion", "lightning") var impact_type : String

## Optional argument, checked by components of the hurt box, to activate status effects
@export_enum("fire", "lightning") var elemental_type : String

## Either set by the gun shooting (bullets) or static value (grenades) via the bullets init function
@export var damage: int = 1
var shooter: CharacterBody2D  # reference back to the player
var random_id: int  # set by bullet, for tracking accuracy when a gun fires multiple bullets at the same time ( shotguns )
var knockback_vector: Vector2 = Vector2.ZERO

func _ready():
	shooter = Globals.player

func _on_area_entered(_area):
	# Track bullet
	Events.emit_signal("bullet_hit", get_rid(), random_id)
	emit_signal("enemy_hit")
