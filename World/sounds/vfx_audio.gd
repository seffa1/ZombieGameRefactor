extends AudioStreamPlayer

"""
World audio is audio that is not tied to a specific object in the game.
This is for looping music, looping ambiance, global sound effects.
"""

@onready var sound_map = {
	"sub_hit": preload("res://World/sounds/vfx/FF_HFX_hit_lilac.wav"),
	"piano_loop": preload("res://World/sounds/music/BO_HWD_140_Keys_Loop_Piano_High_Ching_Em.wav"),
	"bomber_round_start": preload("res://Enemies/sounds/ESM_Horror_Game_Vocal_Creature_Banshee_Fetch_Me_Their_Souls_Wet_Designed_Ghost.wav")
}

var _current_sound := stream:
	set(value):
		if value != _current_sound:
			_current_sound = value
			stream = _current_sound

func play_sound(sound_name: String) -> void:
	assert(sound_map.find_key(sound_name) != -1, "Playing a sound that isnt in the map!")
	var sound = sound_map[sound_name]
	self._current_sound = sound
	play()

func fade_out(time: float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -100, time)
	tween.tween_callback(reset)

func reset():
	stop()
	volume_db = -8
