extends Node2D

"""
Path finding logic which updates the velocity component each tick to go towards
the target position (A*), and then calculates any avoidance (context-based-steering). 
The target position is supplied by the owner.
"""
# CONTEXT BASED STEERING STUFF ----------------------
@export var draw_lines: bool = true
var DANGER_DOT_VALUE = .7  # danger vector dot the target direction that is ignored
var ZOMBIE_DANGER_WEIGHT = .7  # How much zombies avoid each other
var ZOMBIE_DANGER_OUTSIDE_WEIGHT = .1  # How much zombies avoid each other when outside
var LOOK_AHEAD = 150
var NUM_RAYS = 9  # Make this an odd number

var ray_directions = []
var interest = []
var danger = []
var chosen_dir = Vector2.ZERO
# ---------------------------------------------------

@export var velocity_component: Node
@export var path_update_interval: float = 1

@onready var path_update_timer: Timer = $updatePathTimer
@onready var nagivation_agent: NavigationAgent2D = $NavigationAgent2D

var movement_direction


func update_target_position(position: Vector2):
	"""
	Each time the player's position changes, a signal goes out. The owner of this
	pathfinding component calls this each time is consumes the signal. An interval
	is used for performance/debugging reasons
	"""
	if position == nagivation_agent.target_position:
		return
	
	if path_update_timer.is_stopped():
		path_update_timer.start(path_update_interval)
		nagivation_agent.target_position = position

func _physics_process(delta):
	if nagivation_agent.is_navigation_finished():
		return
	
	# A* pathfinding velocity update
	movement_direction = to_local(nagivation_agent.get_next_path_position()).normalized()
	velocity_component.accelerate_in_direction(movement_direction)
	
	# Context based steering velocity update
	set_interest(velocity_component.velocity)
	set_danger()
	var chosen_direction = choose_direction()
	velocity_component.accelerate_in_direction(chosen_direction)

func _ready():
	
	# Setup the context array
	interest.resize(NUM_RAYS)
	danger.resize(NUM_RAYS)
	ray_directions.resize(NUM_RAYS)
	
	# creates and evenly rotates unit vectors and adds them to ray_directions
	for i in NUM_RAYS:
		var angle = i * 2 * PI / NUM_RAYS
		ray_directions[i] = Vector2.RIGHT.rotated(angle)

func set_interest(path_direction):
	# only use vectors with position dot products (in the same direction)
	for i in NUM_RAYS:
		var d = ray_directions[i].rotated(rotation).dot(path_direction)

		# ignore vectors which are not pointing in the forward direction
		interest[i] = max(0, d)
#		print(interest)
#		interest[i] = d
	# used for drawing
	queue_redraw()

func set_danger():
	# Cast rays to find danger directions
	# Gets access to the physics space
#	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0, 100))
#	var collision = get_world_2d().direct_space_state.intersect_ray(query)

	var space_state = get_world_2d().direct_space_state
	for i in NUM_RAYS:
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + ray_directions[i].rotated(rotation) * LOOK_AHEAD, 0xFFFFFFFF, [self])
		var collision = space_state.intersect_ray(query)

	# Levels of danger:
	# When populating the  array, don’t just use 0 or 1, but instead calculate a danger “score” 
	# based on the distance of the object. 
	# Then subtract that amount from the interest rather than removing it. 
	# Far away objects will have a small impact while close ones will have more.
		if !collision:
#			print("no collision: " + str(i))
			danger[i] = 0
		else:
			# TODO DEBUGGING:
			# check what the rays are colliding with
			
			print("COLLISION " + str(i))
			print(collision)
			
			var dangerDistance = (collision.position - global_position).length()
			# the closer something is, the larger the danger weight
			var dangerWeight =  1 - dangerDistance / LOOK_AHEAD
#			print(dangerWeight)
			# This lessens the danger amount if its colliding with a zombie instead
			# of a wall
			
			# TODO - check using groups instead
#			if collision["collider"] in get_tree().get_nodes_in_group("Zombies"):
#				dangerWeight *= ZOMBIE_DANGER_WEIGHT
#			else:
#				dangerWeight *= ZOMBIE_DANGER_WEIGHT

			# If the danger ray is in the same direction as the target, lessen its effect
			if interest[i] > DANGER_DOT_VALUE:
				dangerWeight = 0
			danger[i] = dangerWeight

func choose_direction():
	# Eliminate interest in slots with danger
	# Avoidance
	# Rather than a danger item canceling the interest, it could add to the interest in the opposite direction.
	for i in NUM_RAYS:
		if danger[i] > 0.0:
#			interest[i] = 0.0
			# This number dictates how hard a danger vector "pushes" away from a wall
			var magicDangerNumber = 2
			interest[i] -= danger[i] * magicDangerNumber
	# Choose direction based on remaining interest
	chosen_dir = Vector2.ZERO.rotated(rotation)
	
	for i in NUM_RAYS:
		# negative values should effect the dir as much as positive numbers
		var magicDirectionNumber = 1
		if interest[i] < 0:
			chosen_dir += ray_directions[i] *  interest[i] * magicDirectionNumber
		else:
			chosen_dir += ray_directions[i] * interest[i]
			
	chosen_dir = chosen_dir.normalized()
	return chosen_dir

func _draw():
	if draw_lines:
		# Draw the final direction line (adding all interestest and subtracting all dangers)
		draw_line(Vector2.ZERO, chosen_dir.normalized()*200, Color(0,0,0), 1, true)
		# Draw the interest vectors
		for i in NUM_RAYS:
			if interest[i] == null:
				return
			# Green lines are the 'interested in going that direction' lines
			if interest[i] > 0:
				draw_line(Vector2.ZERO, ray_directions[i].normalized()*LOOK_AHEAD*interest[i] , Color.GREEN, 3, true)
			# Red lines are 'ignore that direction' lines
			elif interest[i] == 0:
				draw_line(Vector2.ZERO, ray_directions[i].normalized()*LOOK_AHEAD * 0.1 , Color.RED, 3, true)
			# Blue lines are 'danger, dont go that way' lines
			elif interest[i] < 0:
				draw_line(Vector2.ZERO, ray_directions[i].normalized()*LOOK_AHEAD * -interest[i], Color.BLUE, 3, true)
