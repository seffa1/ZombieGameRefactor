extends Area2D

@onready var sparks: CPUParticles2D = %Sparks
@onready var sparks_audio: AudioStreamPlayer2D = %SparksAudio

signal electrocuted(is_electrocuted: bool)

# The electrocuted state will use these to do damage
var damage_per_second: float
var electrocution_time: float

func electrocute(damage_per_second: float, electrocution_time: float):
	"""
	Called on by the lighting.
	"""
	self.damage_per_second = damage_per_second
	self.electrocution_time = electrocution_time
	emit_signal("electrocuted", true)
	
	sparks.emitting = true
	sparks_audio.play()
	get_tree().create_timer(electrocution_time).timeout.connect(_on_timeout)
	

func _on_timeout():
	print("TIMEOUT")
	emit_signal("electrocuted", false)
	sparks.emitting = false
	sparks_audio.stop()
