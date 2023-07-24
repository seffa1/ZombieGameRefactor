extends Area2D

"""
Tracks the current purchasable item and interacts with it
if called.
"""

@onready var purchasable = null

func _on_area_entered(area):
	purchasable = area
	Events.emit_signal("update_interactable_log", area.get_interactable_message())
	print(purchasable.get_interactable_message())

func _on_area_exited(area):
	purchasable = null
	Events.emit_signal("update_interactable_log", "")

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if purchasable != null:
			purchasable.purchase_item(owner)
