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
var is_penetrating_shot: bool = false

@export_enum("impact", "explosion") var hit_box_type  # helps the gore system choose vfxs

func _ready():
	shooter = Globals.player

func _on_area_entered(_area):
	# If the bullets hitbox hits an enemy hurtbox the bullet dies, unless its 'penetrating', then it keeps going through enemies
	if hit_box_type == 0 and !is_penetrating_shot:
		owner.die()

	# Track bullet
	Events.emit_signal("bullet_hit", get_rid(), random_id)

