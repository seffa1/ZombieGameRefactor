extends HSlider

func _ready() -> void:
	value = GlobalWorldEnvironment.get_environment().adjustment_brightness
	value_changed.connect(_on_value_changed)

func _on_value_changed(_value: float) -> void:
	print(_value)
	GlobalWorldEnvironment.get_environment().adjustment_brightness = _value
