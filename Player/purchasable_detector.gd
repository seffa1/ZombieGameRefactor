extends Area2D

"""
Checks if theres a purchasble overlapping and updates the interable log if thats the case.
If we press the intereact button it will try to purchase.

Note: We should never have more than one purchasable item at a time or an error is asserted
"""

func _process(_delta):
	if has_overlapping_areas():
		assert(len(get_overlapping_areas()) == 1, "Player has two purchasables on top of each other!")
		
		var purchasable_area = get_overlapping_areas()[0]
		if purchasable_area.get_interactable_message() != '':
			Events.emit_signal("update_interactable_log", purchasable_area.get_interactable_message())
	else:
		Events.emit_signal("update_interactable_log", "")
	
	if Input.is_action_just_pressed("interact"):
		if len(get_overlapping_areas()) > 0:
			assert(len(get_overlapping_areas()) == 1, "Player has two purchasbles he is trying to buy!")
			
			var purchasable_area = get_overlapping_areas()[0]
			if purchasable_area.can_be_purchased:
				purchasable_area.purchase_item(owner)
