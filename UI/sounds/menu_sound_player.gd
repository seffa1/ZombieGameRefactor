extends AudioStreamPlayer2D


@export var sound_close: AudioStream
@export var sound_confirm: AudioStream
@export var sound_hide: AudioStream
@export var sound_open: AudioStream
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

func play_hide() -> void:
	self._current_sound = sound_hide
	play()
