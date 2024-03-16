extends Node2D

"""
Must be a child of a hurtbox.
Creates the 'impact' that occurs when a hurtbox is damaged or destroyed:
	EG: knockbacks, blood sprays, sounds, etc.
"""

@onready var hurt_box: Area2D = $".."

@export_category('Components To Link')
@export var gore_vfx: Node2D
@export var zombie_groan_audio: Node
@export var velocity_component: Node


# Called when the node enters the scene tree for the first time.
func _ready():
	hurt_box.hurt_box_hit.connect(_handle_hit)
	hurt_box.hurt_box_destroyed.connect(_handle_hurtbox_destroy)

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
			
	# gore system tracks the last position a bullet / grenade / etc. did damage to it
	# so when the zombie dies, it knows the position of the thing that killed it
	# so we can spawn VFX items in the correct position (moving away from that position)
	gore_vfx.last_damage_position = area.global_position


func _handle_hurtbox_destroy(body_part: String, area: Area2D):
	
	match area.impact_type:
		'bullet':
			_apply_knockback(area)
			gore_vfx.bullet_impact(area.knockback_vector)
			# TODO - head shot VFX and special animation
			# if body_part == "head":
		'explosion':
			# If an explosion kills, then send body parts flying and instantly remove the zombie with no death animation
			_apply_knockback(area)
			gore_vfx.explosion_death(global_position, area.global_position)
			Events.emit_signal("zombie_death", owner)
			
			if hurt_box.body_part == "head":
				owner.queue_free()

func _apply_knockback(area: Area2D):
	var knockback_vector = area.knockback_vector
	velocity_component.impulse_in_direction(knockback_vector)
	owner.velocity = velocity_component.velocity


