extends Area2D

"""
Checks if theres a purchasble overlapping and updates the interable log if thats the case.
If we press the intereact button it will try to purchase.

Note: We should never have more than one purchasable item at a time or an error is asserted
"""

func _process(_delta):
	# The mystery box is the only case where two purchasables will be on top of each
	# but the box will not 'be purchasble' while the weapon pickup IS
	# so we should only see the message of whatever is purchasable
	var num_of_purchasables = 0
	
	if has_overlapping_areas():
		for area in get_overlapping_areas():
			if area.can_be_purchased:
				num_of_purchasables += 1

				var message = area.get_interactable_message(owner)
				if message != '':
					Events.emit_signal("update_interactable_log", message)
	
	assert(num_of_purchasableas <= 1, "Player has two purchasables on top of each other!")
	if num_of_purchasables == 0:
		Events.emit_signal("update_interactable_log", "")

	if Input.is_action_just_pressed("interact"):
		if len(get_overlapping_areas()) > 0:
			for purchasable_area in get_overlapping_areas():
				if purchasable_area.can_be_purchased:
					purchasable_area.purchase_item(owner)
