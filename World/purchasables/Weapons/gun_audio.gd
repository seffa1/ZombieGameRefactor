extends Node2D

"""
Controls all sounds for all guns. If a gun needs more customized sounds, inherit from this and add more functions
"""

# Nodes
@onready var audio = $AudioStreamPlayer2D  # Handles everything else
@onready var audio_variator = $AudioVariator  # handles gun shots only

# Sounds
@export var audio_reload_start: AudioStream
@export var audio_reload_finished: AudioStream
@export var audio_shoot_gun_shot: AudioStream
@export var audio_shoot_gun_shot_level_up: AudioStream
@onready var audio_shoot_empty_clip: AudioStream = preload("res://World/purchasables/Weapons/shared/audio/ESM_FVESK_fx_foley_ui_clip_podracer_steel_gun_empty_clip.wav")


func _ready():
	audio_variator.stream = audio_shoot_gun_shot

func level_up(weapon_level):
	audio_variator.stream = audio_shoot_gun_shot_level_up

func play_audio_shoot_gun_shot():
	audio_variator.play_audio()

func play_audio_reload_start():
	audio.stream = audio_reload_start
	audio.play()

func play_audio_reload_finished():
	audio.stream = audio_reload_finished
	audio.play()

func play_audio_shoot_empty_clip():
	audio.stream = audio_shoot_empty_clip
	audio.play()

