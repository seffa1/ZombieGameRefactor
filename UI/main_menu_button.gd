extends Button

@onready var light: Light2D = $LightFlicker

func _ready():
	light.flicker = false

func toggle_flicker(value: bool):
	light.flicker = value
