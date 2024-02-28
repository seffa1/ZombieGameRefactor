extends CanvasModulate

func tween_color(toColor: Color, time: float):
	print('tweening color')
	print(toColor)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate", toColor, 1)

func _process(delta):
	print(self_modulate)
