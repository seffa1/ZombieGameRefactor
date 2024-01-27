extends Node

@onready var light = $".."
@export var default_is_on: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.power_activated.connect(_on_power_on)
	light.enabled = default_is_on


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_power_on():
	light.enabled = true
