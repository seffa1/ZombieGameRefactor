extends "res://VFX/self_freeing_component.gd"

@onready var audio = $AudioVariator

func _play_shell_hit_sound():
	audio.play_audio()

func _on_animation_finished():
	"""
	Defined for child classes if they need to do something unique.
	"""
	$ScaleController/Sprite2D.z_index = 0
