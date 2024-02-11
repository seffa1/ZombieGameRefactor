extends Node2D

"""
MUST BE A CHILD OF A HIT BOX COMPONENT
"""


# The enemy checks this when they are hit, to determine which death/impact VFX to play
@export_enum("impact", "explosion", "lightning") var impact_type : String



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
