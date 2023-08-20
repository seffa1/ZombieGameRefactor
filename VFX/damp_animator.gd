extends Node2D

"""
This node tweens the damping values to mimic an object getting throw into the air
and landing on the grown. In the air there should be no dampinging other then from air resistance.
Once landing on the group, the value is based on the friction on the ground. This component
can be added to any self-freeing-component object.
"""

@export var final_linear_damp_value: int
@export var final_angular_damp_value: int
@export var hang_time: float  # how long the item is in the air (no damping) before it hits the ground
@export var tween_duration: float  # once the item hits the ground, how fast it slows down

@onready var timer: Timer = $Timer

func _ready():
	timer.start(hang_time)

func _on_timer_timeout():
	var tween1 = get_tree().create_tween()
	tween1.tween_property(owner, "linear_damp", final_linear_damp_value, tween_duration)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(owner, "angular_damp", final_angular_damp_value, tween_duration)


