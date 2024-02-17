extends Line2D

@export_range(0.5, 3.0, 0.1) var spread_angle: float = PI/4.0
@export_range(1, 36) var segments: int = 12

@onready var sparks: CPUParticles2D = $Sparks
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var hit_box: Area2D = $HitBoxComponent
@onready var hit_box_collision: CollisionShape2D = $HitBoxComponent/CollisionShape2D

func _ready():
	hit_box.enemy_hit.connect(_handle_enemy_hit)

func create(start: Vector2, end: Vector2):
	ray_cast.global_position = start
	ray_cast.target_position = end - start
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding():
		end = ray_cast.get_collision_point()
	
	# Generate the points that make up the jagged lightning arc trail
	var _points := []
	var _current := start
	var _segment_length := start.distance_to(end) / segments
	
	_points.append(start)

	for segment in range(segments):
		# Face the end point and extent towards it
		# Rotate a random amount to get next point
		var _rotation := randf_range(-spread_angle / 2, spread_angle / 2)
		var _new := _current + (_current.direction_to(end) * _segment_length).rotated(_rotation)
		_points.append(_new)
		_current = _new
		
	_points.append(end)
	points = _points
	
	sparks.global_position = end
	
	# Set the hit box component
	var hit_box_shape: SegmentShape2D = hit_box_collision.get_shape()
	hit_box_shape.a = to_local(start)
	hit_box_shape.b = to_local(end)
	hit_box_collision.disabled = false

	
func _handle_enemy_hit():
	hit_box_collision.set_deferred("disabled", true)
