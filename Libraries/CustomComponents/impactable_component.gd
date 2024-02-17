extends Node2D

"""
Must be a child of a hurtbox.
Controls what happens when hurtbox is struct like, knockbacks, spawning blood, playing sounds, spawning vfx, etc.
"""

@onready var hurt_box: Area2D = $".."

@export_category('Components To Link')
@export var health_component: Node2D
@export var status_reciever: Node2D
@export var gore_vfx: Node2D
@export var zombie_groan_audio: Node
@export var velocity_component: Node

@export_category('Body Parts')
@export var spawn_body_part_on_death: bool = false
@export var body_part_to_spawn: PackedScene
## Allows one impact to trigger a chain of imacts. So if an upper arm is destroyed, a lower arm can also get destroyed
@export var child_impactable_component: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	hurt_box.hurt_box_hit.connect(_handle_hit)
	hurt_box.hurt_box_destroyed.connect(_handle_hurtbox_destroy)
	
	if spawn_body_part_on_death:
		assert(body_part_to_spawn, "You forgot to set a body part to spawn")

func _handle_hit(body_part: String, area: Area2D):
	""" The area here is the hitbox that is overlapping. """	

	match area.impact_type:
		'bullet':
			_apply_knockback(area)
			gore_vfx.bullet_impact(area.knockback_vector)
			if randf_range(0, 100) > 90:
				zombie_groan_audio.play_short()
		'explosion':
			_apply_knockback(area)
			gore_vfx.play_splatter()
			gore_vfx.bullet_impact(area.knockback_vector)
		'lightning':
			gore_vfx.play_splatter()
			if randf_range(0, 100) > 90:
				zombie_groan_audio.play_short()
			
	# gore system tracks the last position a bullet / grenade / etc. did damage to it
	# so when the zombie dies, it knows the position of the thing that killed it
	# so we can spawn VFX items in the correct position (moving away from that position)
	gore_vfx.last_damage_position = area.global_position


func _handle_hurtbox_destroy(body_part: String, area: Area2D):
	
	match area.impact_type:
		'bullet':
			_apply_knockback(area)
			zombie_groan_audio.play_death()
			gore_vfx.play_splatter()
			gore_vfx.bullet_impact(area.knockback_vector)

			_spawn_body_part()
			for child_impact in child_impactable_component:
				child_impact._spawn_body_part()

			# TODO - head shot VFX and special animation
			# if body_part == "head":
		'explosion':
			# If an explosion kills, then send body parts flying and instantly remove the zombie with no death animation
			_apply_knockback(area)
			gore_vfx.explosion_death(global_position, area.global_position)
			Events.emit_signal("zombie_death", owner)
			owner.queue_free()
		'lightning':
			_apply_knockback(area)
			gore_vfx.explosion_death(global_position, area.global_position)
			Events.emit_signal("zombie_death", owner)
			owner.queue_free()

func _apply_knockback(area: Area2D):
	var knockback_vector = area.knockback_vector
	velocity_component.impulse_in_direction(knockback_vector)
	owner.velocity = velocity_component.velocity

func _spawn_body_part():
	if !spawn_body_part_on_death:
		return

	var _part = body_part_to_spawn.instantiate()
	_part.spawn_animation = 1
	_part.global_position = global_position
	_part.global_rotation = global_rotation - deg_to_rad(180)
	ObjectRegistry.register_effect(_part)
