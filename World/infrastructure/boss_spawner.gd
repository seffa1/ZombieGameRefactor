extends Node2D

@onready var boss_zombie = preload("res://Enemies/Boss/ZombieBoss.tscn")

@export var zombie_container: Node

func spawn() -> void:
	var zombie_instance = boss_zombie.instantiate()
	zombie_instance.global_position = global_position
	zombie_container.add_child(zombie_instance)
