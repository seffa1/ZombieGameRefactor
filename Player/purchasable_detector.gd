extends Area2D

"""
Tracks the current purchasable items and interacts with them
if called.

Note: We should never have more than one purchasable item at a time
EXCEPT for a weapon and its ammo. However those are setup to toggle can_be_purchased
so the player can never purchase a weapon and ammo at the same time.
"""

@onready var purchasables = []

func _on_area_entered(area):
	purchasables.append(area)
	if area.get_interactable_message() != "":
		Events.emit_signal("update_interactable_log", area.get_interactable_message())

func _on_area_exited(area):
	purchasables.erase(area)
	Events.emit_signal("update_interactable_log", "")

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		for purchasable in purchasables:
			if purchasable.can_be_purchased:
				purchasable.purchase_item(owner)
