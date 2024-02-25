extends Node2D

## Must link nodes or it throws an error
@export_category('Nodes to link')
@export var hurt_box_component: Area2D
@export var health_component: Node2D

@export_category('Configuration')
## Once the total damage from a fire type hitbox is received, trigger the vfx
@export_range(0, 9999999) var damage_until_ignition: int
## Prevents and/or resets the vfx
@export var is_flamable: bool = true
@export_range(1.0, 99.0, .1) var damage_per_second: float = 25.0

@onready var particles: Node2D = %Particles
var damage_received: int = 0
var ignited: bool = false

var DAMAGE_TYPE = 'fire'

func _ready():
	assert(hurt_box_component, "You forget to link the hurt box component")
	assert(get_parent().visible, 'Flamable component cant be seen because of non-visible parent')
	assert(Globals.DAMAGE_TYPES.find(DAMAGE_TYPE) != -1, 'Undeclared damage type')
	
	hurt_box_component.hurt_box_hit.connect(_handle_hit)
	health_component.health_at_zero.connect(_handle_health_zero)
	
func _handle_hit(body_part: String, area: Area2D):
	if area.elemental_type != "fire":
		return
		
	damage_received += area.damage
	
	if damage_received >= damage_until_ignition:
		ignite()

func _handle_health_zero():
	for particle in particles.get_children():
		particle.emitting = false
	ignited = false

func ignite():
	ignited = true
	for particle in particles.get_children():
		particle.emitting = true
	
func _process(delta):
	if !ignited:
		return

	var damage = delta * damage_per_second
	health_component.health -= damage
	health_component.set_damage_source(DAMAGE_TYPE)
	
