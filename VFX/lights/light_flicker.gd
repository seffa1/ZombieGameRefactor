extends PointLight2D

@export var flicker_interval: float = .2
@export var brightness_offset: float = .5
@export var brightness_multiplyer: float = 3.0
@export var flicker: bool = true:
	set(value):
		flicker = value
		energy = 0

@onready var flicker_timer = $FlickerTimer
var _noise = FastNoiseLite.new()

func _ready():
	randomize()
	# This code is straight from the random_number_generation section in the docs
	_noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
	_noise.seed = randi()
	_noise.fractal_octaves = 4
	_noise.frequency = 1.0 / 20.0

var i = 0
func _process(delta):
	if !flicker:
		return
	
	# Get a new noise value
	if flicker_timer.is_stopped():
		flicker_timer.start(flicker_interval)
		var noise_value = _noise.get_noise_1d(i)
		
		# Set energy value based on noise
		energy = brightness_offset + (abs(noise_value)  * brightness_multiplyer)
		i += 1
		if i >= 100:
			i = 0

