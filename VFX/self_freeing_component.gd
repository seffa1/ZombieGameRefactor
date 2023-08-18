extends RigidBody2D


@export var free_time: float
@onready var timer: Timer = $Timer

func _ready():
	timer.start(free_time)

func _on_timer_timeout():
	queue_free()
