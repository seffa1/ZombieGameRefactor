extends AudioStreamPlayer

"""
World audio is audio that is not tied to a specific object in the game.
This is for looping music, looping ambiance, global sound effects.
"""

# Music
@onready var piano_loop = preload("res://World/sounds/music/BO_HWD_140_Keys_Loop_Piano_High_Ching_Em.wav")

# Ambiance
@onready var zombie_ambiance = preload("res://World/sounds/ambiance/FF_HFFX_sfx_creature_zombie_hoard_purple.wav")
@onready var thunder_ambiance = preload("res://World/sounds/ambiance/FF_HFFX_atmosphere_thunder_dark_sky.wav")

# VFX
@onready var sub_hit = preload("res://World/sounds/ambiance/FF_HFX_hit_lilac.wav")

var _current_sound := stream:
	set(value):
		if value != _current_sound:
			_current_sound = value
			stream = _current_sound

var sound_map = {
	"piano_loop": piano_loop,
	"zombie_ambiance": zombie_ambiance,
	"thunder_ambiance": thunder_ambiance,
	"sub_hit": sub_hit,
}


func play_sound(sound_name: String) -> void:
	assert(sound_map.find_key(sound_name) != -1, "Playing a sound that isnt in the map!")
	var sound = sound_map[sound_name]
	self._current_sound = sound
	play()
