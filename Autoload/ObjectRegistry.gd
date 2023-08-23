extends Node

"""
Creates, maintains, and organizes spawned special effects or projectiles;
objects that should be untied from their spawners' lifespan when freed.
"""

@onready var _effects := $Effects
@onready var _projectiles := $Projectiles

func register_effect(effect: Node) -> void:
	_effects.call_deferred("add_child", effect)

func register_projectile(projectile: Node) -> void:
	_projectiles.add_child(projectile)
