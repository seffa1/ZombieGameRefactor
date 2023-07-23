extends Area2D

"""
Tracks the current purchasable item.
"""

@onready var purchasable = null

func _on_body_entered(body):
	purchasable = body
	Events.emit_signal("update_interactable_log", body.get_interactable_message())

func _on_body_exited(body):
	purchasable = null
	Events.emit_signal("update_interactable_log", "")
