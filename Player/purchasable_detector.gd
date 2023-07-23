extends Area2D

"""
Keeps track of all purchasables within the player's reach.
Signals to the UI what the player can purchase. There should only be
one purchasable at a time ( dont put two things too close together on the map. )
"""

@onready var purchasables: Array = []

func _on_body_entered(body):
	purchasables.append(body)

func _on_body_exited(body):
	purchasables.erase(body)
