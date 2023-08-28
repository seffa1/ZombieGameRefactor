extends Area2D

"""
Regions designate a specific area of the map. When you open a door you enter a 
new region. Regions control the fog of war and will maybe be used by the zombie manager
to control spawns but that remains to be seen.
"""

@onready var animation_player = $AnimationPlayer

func _on_area_entered(area):
	animation_player.play("fade_out")
