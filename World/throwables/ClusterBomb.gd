extends "res://World/throwables/throwable.gd"

@onready var cluster_spawner: Node2D = %ClusterSpawner

func _on_timer_timeout():
	cluster_spawner.spawn_items_outwards()
	queue_free()
