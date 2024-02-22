extends Node2D


"""
Takes a veritey of status' and applys the effect.
"""
@export_group('Nodes to link')
@export var velocity_component: Node
## hurtboxes receving freeze effect
@export var hurtboxes: Array[Area2D]

@export_group('Configuration')
@export var hits_until_freeze: int = 20
@export var velocity_drop_per_point: float = 2.0
@export var modulator: Node2D
@export_color_no_alpha var freeze_color: Color

var hits: int = 0

func _ready():
	assert(hurtboxes, 'You didnt link hurtboxes for freezable')
	assert(velocity_component, 'You didnt link velocity component to freezeable')
	
	for hurtbox in hurtboxes:
		hurtbox.hurt_box_hit.connect(_on_hurtbox_hit)

func _on_hurtbox_hit(body_part: String, area: Area2D):
	velocity_component.slow_down(2.0)
	hits += 1
	
	if hits >= hits_until_freeze:
		_freeze()
		

func _freeze():
	velocity_component.stop()
	# TODO - visual effect
	# make the zombie tinted blue
	modulator.modulate(freeze_color.r, freeze_color.b, freeze_color.g, 1)
	

