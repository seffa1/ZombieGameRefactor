extends AudioStreamPlayer2D

"""
Plays an audio stream while adding variance to the stream's pitch and volume
to get slightly more variation out of the sound.
"""

@onready var audio_start_volume = volume_db
@onready var audio_start_pitch = pitch_scale

@export var pitch_variance: float = 0.04
@export var volume_variance: float = .9

func play_audio():
	_randomize_audio_stream()
	play()

func _randomize_audio_stream():
	"""
	Slightly randomizes the pitch and volume of the audio stream player to make for more 
	varied gun shot sounds using just one audio sample. pitch_amount and volume_amount
	is how great the range of variation is.
	"""
	_reset_audio_stream()
	var pitch_variation = randf_range(-pitch_variance, pitch_variance)
	var volume_variation = randf_range(-volume_variance, volume_variance)
	
	pitch_scale += pitch_variation
	volume_db += volume_variance


func _reset_audio_stream():
	volume_db = audio_start_volume
	pitch_scale = audio_start_pitch
