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
@export_range(1.0, 99.0, .1) var damage_per_second: float = 10.0

@onready var particles: Node2D = %Particles
var damage_received: int = 0
var ignited: bool = false

func _ready():
	assert(hurt_box_component, "You forget to link the hurt box component")
	
	hurt_box_component.hurt_box_hit.connect(_handle_hit)
	
func _handle_hit(body_part: String, area: Area2D):
	if area.elemental_type != "fire":
		return
		
	damage_received += area.damage
	
	if damage_received >= damage_until_ignition:
		ignite()

func ignite():
	ignited = true
	for particle in particles.get_children():
		particle.emitting = true
	
func _process(delta):
	if !ignited:
		return

	var damage = delta * damage_per_second
	health_component.health -= damage
	print('damage ')
	print(damage)
	
