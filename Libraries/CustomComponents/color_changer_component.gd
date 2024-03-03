extends CanvasModulate

func tween_color(toColor: Color, time: float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate", toColor, 1)
