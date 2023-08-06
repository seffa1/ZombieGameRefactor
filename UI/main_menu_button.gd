extends Button

@onready var light: Light2D = $LightFlicker

func _ready():
	light.flicker = false

func _on_mouse_entered():
	light.flicker = true


func _on_mouse_exited():
	light.flicker = false
