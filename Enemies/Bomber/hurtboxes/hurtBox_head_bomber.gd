extends "res://Libraries/CustomComponents/hurt_box_component.gd"

@onready var head_polygon: Polygon2D = %headPolygon
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var is_dead: bool = false

@onready var blood_emitter: CPUParticles2D = %HeadBloodEmitter

signal headless_death
signal explosion_death

func bullet_impact_effect(area: Area2D):
	"""
	Defined for each child class, determines what happens when struck by a bullet.
	
	The area here is a hitbox component which should contain all the
	information we need to take damage, do knockbacks, trigger effects, etc
	from bullets, explosions, or anything else we can take damage from.
	"""
	if is_dead:
		return

	# Spawn bullet impact
	gore_vfx.bullet_impact(area.owner.velocity)
	
	# Apply knock back
	var knock_back = area.bullet_knockback
	var knock_back_vector = area.owner.velocity.normalized() * knock_back
	owner.velocity_component.impulse_in_direction(knock_back_vector)
	owner.velocity = owner.velocity_component.velocity

	# Whether the bomber is killed with a shot or a grenade, the result is the same explosive death
	if health_component.health <= 0:
		death_effect()

func explosion_impact_effect(area: Area2D):
	"""
	Defined for each child class, determines what happens when struck by an explosion.
	
	The area here is a hitbox component which should contain all the
	information we need to take damage, do knockbacks, trigger effects, etc
	from bullets, explosions, or anything else we can take damage from.
	"""
	if is_dead:
		return

	# Apply knock back
	var knock_back = area.bullet_knockback
	var knock_back_vector = (area.global_position - global_position).normalized() * knock_back
	owner.velocity_component.impulse_in_direction(knock_back_vector)
	owner.velocity = owner.velocity_component.velocity
	
	# Spawn blood vfx
	gore_vfx.play_splatter()
	gore_vfx.bullet_impact(knock_back_vector)
	
	# Whether the bomber is killed with a shot or a grenade, the result is the same explosive death
	if health_component.health <= 0:
		death_effect()

func death_effect():
	is_dead = true
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	collision_shape.set_deferred("disabled", true)

	emit_signal("explosion_death")
