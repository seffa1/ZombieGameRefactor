extends Area2D

"""
All the information which needs to be given to the body which is shot is contained here.
When the hitbox is detected by a hurtbox, that hurt box can get all the information
it needs here to do different things it needs to do based on the hitbox damage, velocity, etc.
"""

signal enemy_hit()
## REQUIRED - Used to determine which death animation to play for enemy if killed by
@export_enum("fire", "frost", "electric", "explosive", "bullet") var damage_type: String
## OPTIONAL - Used to trigger bullet impact vfx like blood splatters and knockbacks
@export_enum("bullet", "explosion", "lightning") var impact_type : String
## OPTIONAL - Used to trigger status effects, 'on fire', 'frozen', 'electrocuted', etc.
@export_enum("fire", "lightning", "frost") var elemental_type : String

## Either set by the gun shooting (bullets) or static value (grenades) via the bullets init function
@export var damage: int = 1
var shooter: CharacterBody2D  # reference back to the player
var random_id: int  # set by bullet, for tracking accuracy when a gun fires multiple bullets at the same time ( shotguns )
var knockback_vector: Vector2 = Vector2.ZERO

func _ready():
	# if the player dies and something spawns, this prevents a crash
	if Globals.player:
		shooter = Globals.player
	assert(damage_type, 'You didnt set the damage type')

func _on_area_entered(_area):
	# Track bullet
	Events.emit_signal("bullet_hit", get_rid(), random_id)
	emit_signal("enemy_hit")

func get_collision_shape() -> CollisionShape2D:  
	var shape = get_child(0)
	assert(shape.is_class('CollisionShape2D'), 'The first child of the hitbox component should be the CollisionShape2D')
	return shape
