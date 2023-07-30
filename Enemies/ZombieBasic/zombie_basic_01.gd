extends CharacterBody2D

"""
This should be a lightweight script which glues the different components together.
"""

@onready var health_component: Node2D = $HealthComponent
@onready var pathfinding_component: Node2D = $PathfindingComponent
@onready var velocity_component: Node = $VelocityComponent

func _ready():
	Events.player_position_change.connect(_on_player_position_changed)

func _on_player_position_changed(player_position: Vector2):
	print("Player position changed: " + str(player_position))
	pathfinding_component.update_target_position(player_position)
