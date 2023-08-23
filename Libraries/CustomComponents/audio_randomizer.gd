extends AudioStreamPlayer2D

"""
Drag and drop multiple audio clips into the export array to set up.
"""

@export var audio_clips: Array[AudioStreamWAV]


func play_random():
	var index = randi_range(0, len(audio_clips) -1 )
	stream = audio_clips[index]
	play()
