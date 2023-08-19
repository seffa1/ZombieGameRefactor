extends "res://VFX/self_freeing_component.gd"

@onready var audio = $AudioVariator

func _play_shell_hit_sound():
	audio.play_audio()
