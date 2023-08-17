extends Sprite2D

"""
This script keeps the gun sprite tracked to the skeleton's right hand positon and rotation.
"""

@onready var right_hand = $"../HandPosition"


func _process(_delta):
	position = right_hand.position
	rotation = right_hand.rotation
