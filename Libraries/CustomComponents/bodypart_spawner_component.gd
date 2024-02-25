extends Node2D

"""
Spawns a body part at its current position when assocatiated health component hits zero.
Can also trigger child spawners to spawn their body part.

Once it spawns a body part, it queue frees.
"""

@export_category('Body Parts')
@export var health_component: Node2D
@export var gore: Node2D
@export var spawn_body_part_on_death: bool = true
@export var body_part_to_spawn: PackedScene
## Allows one impact to trigger a chain of imacts. So if an upper arm is destroyed, a lower arm can also get destroyed
@export var child_impactable_component: Array[Node2D]


func _ready():
	health_component.health_at_zero.connect(_handle_health_at_zero)
	
	if spawn_body_part_on_death:
		assert(body_part_to_spawn, "You forgot to set a body part to spawn")
		
func _handle_health_at_zero():
	_spawn_body_part()
	for child_impact in child_impactable_component:
		if is_instance_valid(child_impact):
			child_impact._spawn_body_part()

func _spawn_body_part():
	if !spawn_body_part_on_death:
		return

	var _part = body_part_to_spawn.instantiate()
	_part.spawn_animation = 1
	_part.global_position = global_position
	_part.global_rotation = global_rotation - deg_to_rad(180)
	ObjectRegistry.register_effect(_part)

	gore.bullet_impact(Vector2.RIGHT.rotated(global_rotation))
	queue_free()
