extends PointLight2D

@export var max_charge_value: float = 50.0

@export var flicker_interval: float = .2
@export var max_brightness_offset: float = .5
@export var max_brightness_multiplyer: float = 3.0
@export var flicker: bool = true:
	set(value):
		flicker = value
		energy = 0

@onready var flicker_timer = $FlickerTimer
var _noise = FastNoiseLite.new()

var brightness_offset: float = 0.0
var brightness_multiplyer: float = 0.0

var brightness_offset_per_charge: float
var brightness_multiplyer_per_charge: float

func _ready():
	randomize()
	# This code is straight from the random_number_generation section in the docs
	_noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
	_noise.seed = randi()
	_noise.fractal_octaves = 4
	_noise.frequency = 1.0 / 20.0
	
	brightness_offset_per_charge = max_brightness_offset / max_charge_value
	brightness_multiplyer_per_charge = max_brightness_multiplyer / max_charge_value

func charge():
	brightness_offset += brightness_offset_per_charge
	brightness_multiplyer += brightness_multiplyer_per_charge

var i = 0
func _process(_delta):
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

