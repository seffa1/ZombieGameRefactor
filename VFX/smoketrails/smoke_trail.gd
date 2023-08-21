extends Line2D

@export var limited_lifetime := false
@export var tick_speed := 0.05
@export var wildness := 3.0  # how 'wild' the line2D will be moving
@export var min_spawn_distance := 5.0

var gravity := Vector2.UP
var lifetime := [3, 5]
var tick := 0.0
var wild_speed := 0.1
var point_age := [0.0]  # points increase in 'wildness' the older it is

func _ready():
	set_as_top_level(true)

	clear_points()

	# Fade the line out
	if limited_lifetime:
		stop()

func stop():
	var tween = get_tree().create_tween()
	tween.finished.connect(_on_tween_completed)
	tween.tween_property(
			self, 
			"modulate:a", 
			0.0, 
			randf_range(lifetime[0], lifetime[1])
		).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)

func _process(delta):
	print(global_position)
	# Do this to gain more control over the rate of the line2D changes
	if tick > tick_speed:
		tick = 0
		# iterate through the points of the lines
		for point in range(get_point_count()):
			# increase point age
			point_age[point] += 5 * delta
			# Add gravity and a random vector 2
			var rand_vector := Vector2(randf_range(-wild_speed, wild_speed), randf_range(-wild_speed, wild_speed))
			points[point] += gravity + (rand_vector * wildness * point_age[point])
			
	else:
		tick += delta

# override the add point function of the line 2D
@warning_ignore("native_method_override")
func add_point(point_pos:Vector2, at_pos := -1):
	# Check the distance between the last point added, and the point that is about to get added
	# so we can control it so we dont have too many points squished together
	if get_point_count() > 0 and point_pos.distance_to( points[get_point_count() - 1] ) < min_spawn_distance:
		return

	# If we did add a point, add a new point age to the array
	point_age.append(0.0)
	
	# Then call the original add_point function of the line2D
	super.add_point(point_pos, at_pos)


func _on_tween_completed():
	queue_free()
