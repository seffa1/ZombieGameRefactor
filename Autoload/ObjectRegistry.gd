extends Node

"""
Creates, maintains, and organizes spawned special effects or projectiles;
objects that should be untied from their spawners' lifespan when freed.
"""

@onready var _effects := $Effects
@onready var _projectiles := $Projectiles
@onready var _equipment := $Equipment

func register_equipment(equipment: Node) -> void:
	_equipment.call_deferred("add_child", equipment)

func register_effect(effect: Node) -> void:
	_effects.call_deferred("add_child", effect)

func register_projectile(projectile: Node) -> void:
	_projectiles.add_child(projectile)

func clear_registry():
	for node in _effects.get_children():
		node.queue_free()
	for node in _projectiles.get_children():
		node.queue_free()
	for node in _equipment.get_children():
		node.queue_free()
