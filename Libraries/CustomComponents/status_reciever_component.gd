extends Node2D


"""
Takes a veritey of status' and applys the effect.
"""

@export var velocity_component: Node
@export var health_component: Node2D

func slow_down():
	# TODO - change velocity_component max velocity
	return
	
func speed_up():
	# TODO - change velocity_component max velocity
	return
	
func increase_health():
	# TODO - change health_component max health
	return

func decrease_health():
	# TODO - change health_component max health
	return

func light_on_fire():
	# TODO - spawns a fire effect scene
	# calls the health component to do a DOT effect
	# health_component.DOT(amount_per_tick, seconds_per_tick, total_ticks)
	return
	
