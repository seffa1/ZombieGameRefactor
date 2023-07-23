extends Area2D

"""
Tracks the current purchasable item.
"""

@onready var purchasable = null

func _on_area_entered(area):
	purchasable = area
	Events.emit_signal("update_interactable_log", area.get_interactable_message())
	print(purchasable.get_interactable_message())

func _on_area_exited(area):
	purchasable = null
	Events.emit_signal("update_interactable_log", "")
