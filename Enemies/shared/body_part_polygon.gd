extends Polygon2D

"""
If a linked hurtbox is destroyed, hides itself to appear like its been blown off
"""

@export var health_components: Array[Node2D]

func _ready():
	assert(health_components, "you didnt assign the health component for the body part polygon")
	
	for health_component in health_components:
		health_component.health_at_zero.connect(_handle_health_detroyed)
	
func _handle_health_detroyed():
	hide()
