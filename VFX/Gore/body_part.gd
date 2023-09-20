extends "res://VFX/self_freeing_component.gd"


@onready var audio = $AudioStreamPlayer2D


func _ready():
	if randi_range(0, 4) == 4:
		$BloodEmitter.emitting = true
	super()

func _on_animation_finished():
	"""
	Defined for child classes if they need to do something unique.
	"""
	$ScaleController.z_index = 1
