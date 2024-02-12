extends Polygon2D

"""
If a linked hurtbox is destroyed, hides itself to appear like its been blown off
"""

@export var hurt_boxes: Array[Area2D]

func _ready():
	assert(hurt_boxes, "you didnt assign the hurtbox for the body part polygon")
	
	for hurt_box in hurt_boxes:
		hurt_box.hurt_box_destroyed.connect(_handle_hurtbox_detroyed)
	
func _handle_hurtbox_detroyed():
	hide()
