extends "res://VFX/self_freeing_component.gd"


@onready var audio = $AudioStreamPlayer2D


func _ready():
	if randi_range(0, 4) == 4:
		$BloodEmitter.emitting = true
	super()
