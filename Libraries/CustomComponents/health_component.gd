extends Node2D


"""
Contains all health-related logic and emits related signals.
If health would drop to zero, and we have a giver component, give money
to the player.
"""

@export var giver_component: Node2D
@export var max_health: int
