extends HSlider

"""
Must have an autoloaded Environment node called 'GlobalWorldEnvironment'.
The Environment must have background mode set to 'Canvas' in and have
'adjustment' enabled.
"""

@export var reset_value = 1.0

func _ready() -> void:
	value = GlobalWorldEnvironment.get_environment().adjustment_brightness
	value_changed.connect(_on_value_changed)

func _on_value_changed(_value: float) -> void:
	print(_value)
	GlobalWorldEnvironment.get_environment().adjustment_brightness = _value

func reset():
	value = reset_value
