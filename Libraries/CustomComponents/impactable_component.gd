extends Node2D

"""
MUST BE A CHILD OF A HURTBOX
"""

@onready var hurt_box: Area2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	hurt_box.enemy_hit.connect(_handle_hit)


func _handle_hit(body_part: String, area: Area2D):
	""" The area here is the bullet that hit us. """
	pass
