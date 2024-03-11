extends PointLight2D

@onready var alarm_sound: AudioStreamPlayer2D = %AlarmSound
@onready var sound_timer: Timer = %SoundInterval

@export var frequency: float = 5.0
@export var amplitude: float = 3.0
@export var start_alarm: bool = false
@export var sound_interval: float = 1.0

var time: float
var max_sin: float
var alarm_on: bool

func start():
	time = 0
	set_process(true)
	alarm_sound.play()
	sound_timer.start(sound_interval)
	alarm_on = true

func stop():
	time = 0
	set_process(false)
	alarm_on = false

func _ready():
	set_process(start_alarm)
	alarm_on = (start_alarm)
	if alarm_on:
		alarm_sound.play()
		sound_timer.start(sound_interval)
	else:
		energy = 0

func _process(delta):
	time += delta
	energy = get_sine()

func get_sine():
	return (sin(time * frequency) + 1) * amplitude

func _on_sound_interval_timeout():
	if alarm_on:
		print('playing sound')
		alarm_sound.play()
		sound_timer.start(sound_interval)
	
