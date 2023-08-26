extends AudioStreamPlayer2D


@export var sound_close: AudioStream = preload("res://UI/sounds/button_clicks/GLTCH_SFX_LatchImpact6.wav")
@export var sound_confirm: AudioStream = preload("res://UI/sounds/button_clicks/ESM_Battle_Game_Open_UI_Military_Switch_Next_Page_Turn_Navigation_Button_3_One_Shot.wav")
@export var sound_hover: AudioStream = preload("res://UI/sounds/button_clicks/ESM_Kids_Game_Object_Mechanical_Button_Press_03_Switch_Recorder.wav")
@export var sound_open: AudioStream = preload("res://UI/sounds/button_clicks/ESM_GT_cinematic_fx_UI_organic_button_press_04.wav")
@export var sound_select: AudioStream

var _current_sound := stream:
	set(value):
		if value != _current_sound:
			_current_sound = value
			stream = _current_sound

func play_open() -> void:
	self._current_sound = sound_open
	play()

func play_close() -> void:
	self._current_sound = sound_close
	play()

func play_confirm() -> void:
	self._current_sound =sound_confirm
	play()

func play_select() -> void:
	self._current_sound =sound_select
	play()

func play_hover() -> void:
	self._current_sound = sound_hover
	play()
