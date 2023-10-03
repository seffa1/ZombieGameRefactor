extends Node2D

"""
Spawned by the vessel charge when a zombie is killed in the vessel area.
"""

@export var speed: float = 0.0
var speed_increase: float = 0.0

var target_location: Vector2
var target_vessel_id

func init(location: Vector2, vessel_id):
	target_vessel_id = vessel_id
	target_location = location
	
func _ready():
	# TODO - add spawn animation
	# TODO - add flight animation
	return

func _process(delta):
	if !target_location:
		return
	
	var distance_vector = (target_location - global_position)
	
	if distance_vector.length() <= 10:
		Events.emit_signal("vessel_charged", target_vessel_id)
		# TODO - add despawn animation
		queue_free()
	
	var velocity_vector = distance_vector.normalized() * (speed + speed_increase)
	# Makes the velocity ease in (exponential increase)
	speed_increase += (300.0 * delta) + speed_increase * .04
	global_position += velocity_vector * delta
