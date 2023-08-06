extends Light2D


@onready var timer: Timer = $Timer
@export var blink_interval: float = 1
@export var brightness_min: float = 0
@export var brightness_max: float = 2
@export var blinking: bool = true

func _ready():
	energy = brightness_min

func _process(delta):
	if !blinking:
		return
		
	if timer.is_stopped():
		timer.start(blink_interval)
		energy = brightness_max if energy == brightness_min else brightness_min
