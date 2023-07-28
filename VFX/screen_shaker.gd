extends Node2D

# Settings
enum Type {Random, Sine}
@export var CAMERA_SHAKE_TYPE = Type.Random

# Counters
var camera_shake_intensity = 0.0
var camera_shake_duration = 0.0

var camera  # This is set by the Game Initializer

func _ready():
	Events.connect("shake_screen", shake)

func shake(intensity, duration):
	
	# Set the shake parameters
	if intensity > camera_shake_intensity and duration > camera_shake_duration:
		camera_shake_intensity = intensity
		camera_shake_duration = duration
		
func _process(delta):
	
	# Stop shaking if the camera_shake_duration timer is down to zero
	if camera_shake_duration <= 0:
		# Reset the camera when the shaking is done
		camera.offset = Vector2.ZERO
		camera_shake_intensity = 0.0
		camera_shake_duration = 0.0
		return
		
	# Subtract the elapsed time from the camera_shake_duration
	# so that it eventually ends
	#
	# You can do other fun stuff here too like have the intensity
	# decay gradually so that the shake tapers off
	camera_shake_duration = camera_shake_duration - delta
	
	# Shake it
	var offset = Vector2.ZERO
	
	if CAMERA_SHAKE_TYPE == Type.Random:
		# Random shake
		# Chaos
		# Madness
		#
		# Personally, I like this best because players don't notice
		# any difference in the thick of battle when the shakes are short
		# and because it's dead simple.
		offset = Vector2(randf(), randf()) * camera_shake_intensity
		
	if CAMERA_SHAKE_TYPE == Type.Sine:
		# Sine wave based shake
		#
		# Play around with the magic numbers to adjust the feel
		#
		# Basing the sine wave off of get_ticks_msec ensures that
		# the returned value is continuous and smooth
		offset = Vector2(sin(Time.get_ticks_msec() * 0.03), sin(Time.get_ticks_msec() * 0.07)) * camera_shake_intensity * 0.5
	
	camera.offset = offset
