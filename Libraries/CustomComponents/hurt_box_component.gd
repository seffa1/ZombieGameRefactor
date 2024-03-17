extends Area2D

"""
Detects collision with a hitbox, damages the health, and emits a signal when it takes a hit or dies.
"""

@export_category("Basic Setup")
@export_enum("head", "leftLower", "leftUpper", "rightLower", "rightUpper") var body_part: String
@export var health_component: Node2D
@export var collision_shape: CollisionShape2D

@export_category("Damage Modifications")
@export var damage_multiplier: float = 1.0
@export var resist_explosion: bool = false

@export_category("Collision Control")
## If true, and associated health compoent hits zero, calls the detroy method of each child hurtbox ( like cutton of an apendage )
@export var is_destroyable: bool = true
@export var child_hurtboxes: Array[Area2D]
## If true, sets health zomponent to zero on hit
@export var one_shot_mode: bool = false

signal hurt_box_hit(body_part: String, area: Area2D)
signal hurt_box_destroyed(body_part: String, area: Area2D)

func _ready():
	assert(collision_shape, "You forgot to set a hurtboxes collision shape")

func _on_area_entered(area: Area2D):
	""" 
	The area here is a hitbox component which should contain all the
	information we need to take damage, do knockbacks, trigger effects, etc
	from bullets, explosions, or anything else we can take damage from.
	
	"""

	if one_shot_mode:
		health_component.health = 0
	else:
		var damage = area.damage * damage_multiplier
		if resist_explosion and area.damage_type == "explosive":
			damage = damage * .1
		health_component.health -= damage
	
	health_component.set_damage_source(area.damage_type)
	
	if health_component.health > 0:
		emit_signal("hurt_box_hit", body_part, area)
	else:
		emit_signal("hurt_box_destroyed", body_part, area)
		if is_destroyable:
			collision_shape.set_deferred("disabled", true)
			
			for child_hurtbox in child_hurtboxes:
				child_hurtbox.destroy()

func destroy():
	if is_destroyable:
		collision_shape.set_deferred("disabled", true)
