extends AudioStreamPlayer

"""
World audio is audio that is not tied to a specific object in the game.
This is for looping music, looping ambiance, global sound effects.
"""

@onready var sound_map = {
	"piano_loop": preload("res://World/sounds/music/BO_HWD_140_Keys_Loop_Piano_High_Ching_Em.wav"),
	"zombie_ambiance": preload("res://World/sounds/ambiance/FF_HFFX_sfx_creature_zombie_hoard_purple.wav"),
	"thunder_ambiance": preload("res://World/sounds/ambiance/FF_HFFX_atmosphere_thunder_dark_sky.wav")
}

var _current_sound := stream:
	set(value):
		print("Setting sound")
		if value != _current_sound:
			_current_sound = value
			stream = _current_sound
			print(stream)

func play_sound(sound_name: String) -> void:
	assert(sound_map.find_key(sound_name) != -1, "Playing a sound that isnt in the map!")
	var sound = sound_map[sound_name]
	print(sound)
	print(sound_name)
	self._current_sound = sound
	play()
