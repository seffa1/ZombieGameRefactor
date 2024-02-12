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

@export_category("Collision Control")
## If true, and associated health compoent hits zero, disables collision and any other connected collisions
@export var is_destroyable: bool = true
@export var connected_collisions: Array[CollisionShape2D]

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
	health_component.health -= area.damage * damage_multiplier
	
	if health_component.health > 0:
		emit_signal("hurt_box_hit", body_part, area)
	else:
		emit_signal("hurt_box_destroyed", body_part, area)
		if is_destroyable:
			collision_shape.set_deferred("disabled", true)

			for connected_collision_shape in connected_collisions:
				connected_collision_shape.set_deferred("disabled", true)
