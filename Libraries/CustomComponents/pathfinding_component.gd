extends Node2D

"""
Path finding logic which updates the velocity component each tick to go towards
the target position (A*), and then calculates any avoidance (context-based-steering). 
The target position is supplied by the owner.
"""

@export var velocity_component: Node
@onready var path_update_timer: Timer = $updatePathTimer
@onready var nagivation_agent: NavigationAgent2D = $NavigationAgent2D

# A star pathfinding variables
@export var path_update_interval: float = 1
var movement_direction

# Context Steering Variables
@export var use_context_steering: bool = true
@export var draw_lines: bool = true
var NUM_RAYS = 9  # Make this an odd number
var LOOK_AHEAD = 150  # how far to cast the danger detection ray casts
var DANGER_DOT_VALUE = .7  # at which angle will a danger vector be lessened (since its in the same direction as the desired path). Must be positive.
var ZOMBIE_DANGER_WEIGHT = .7  # How much zombies avoid each other
var ZOMBIE_DANGER_OUTSIDE_WEIGHT = .1  # How much zombies avoid each other when outside
var DANGER_PUSH_FACTOR = 2 # how much danger objects 'push' the entity away

var ray_directions = []
var interest = []
var danger = []
var chosen_dir = Vector2.ZERO


func update_target_position(position: Vector2):
	"""
	When a zombie spawns the target position is a window. Once inside, each time 
	the player's position changes, a signal goes out. The owner of this
	pathfinding component calls this each time is consumes the signal. An interval
	is used for performance/debugging reasons
	"""
	if position == nagivation_agent.target_position:
		return
			
	if path_update_timer.is_stopped():
		path_update_timer.start(path_update_interval)
		nagivation_agent.target_position = position

func get_target_position():
	return nagivation_agent.target_position

func _physics_process(delta):
	# A* pathfinding velocity update
	if nagivation_agent.is_navigation_finished():
		velocity_component.decelerate(delta)
		return
	if (nagivation_agent.target_position - global_position).length() < 50:
		velocity_component.decelerate(delta)
		return
	movement_direction = to_local(nagivation_agent.get_next_path_position()).normalized()
#	velocity_component.velocity = movement_direction
	
	# Context based steering velocity update
	if use_context_steering:
		set_interest(movement_direction)
		set_danger()
		var chosen_direction = choose_direction()
		velocity_component.accelerate_in_direction(chosen_direction, delta)
#		velocity_component.velocity = chosen_direction
	else:
		velocity_component.accelerate_in_direction(movement_direction, delta)

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
	"""
	Based on the given desired path direction, sets the interest in each direction. If an interest
	is in the same direction as the path, then it has a higher weight. If the interest is
	in the opposite direction, we set that interest to 0 (dot product to desired path is negative).
	"""
	for i in NUM_RAYS:
		var d = ray_directions[i].rotated(rotation).dot(path_direction)
		interest[i] = max(0, d) # ignore vectors with negative dot product to desired path direction
		# interest[i] = d  # if you didnt want to ignore these vectors do this instead
	if draw_lines and use_context_steering:
		queue_redraw() # call the canvas to call _draw() for the debug lines

func set_danger():
	"""
	Cast a raycast in each direction with length equal to the LOOK_AHEAD constant.
	If the ray doesn't collide with anything, the danger in that direction is zero.
	
	If a ray collides with something, we check how far away that object is, and create a 
	weight that is larger the closer the collided object is.
	
	We then check if the collided object is a zombie, if so, make adjustments
	to the weight as well. Zombies shouldnt 'push' off each other as much as they
	'push' off of the walls.
	"""	
	
	# Cast rays
	var space_state = get_world_2d().direct_space_state
	for i in NUM_RAYS:
		
		# See PhysicsRayQueryParameters2D in the docs for this example
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + ray_directions[i].rotated(rotation) * LOOK_AHEAD, 0xFFFFFFFF, [self])
		var collision = space_state.intersect_ray(query)
		
		# No collision means no danger in that direction
		if !collision:
			danger[i] = 0
		else:
			
			# Create danger weight based on the inverse of the distance to the collision
			var dangerDistance = (collision.position - global_position).length()
			var dangerWeight =  1 - dangerDistance / LOOK_AHEAD

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
	"""
	The final step in context based steering. We take each interest weight, and subtract
	the corresponding direction's danger weight. When we do this we multiply the danger
	weight by a constant 'DANGER_PUSH_FACTOR' which will control how much a danger weight
	influences the interest weight.
	
	Increasing this constant increases how much danger objects 'push' the entitiy away.
	
	Finally, adjust the chosen direction vector by summing all the directions multiplied by the interest weight
	in that direction.
	"""
	
	# Adjust interest weights based on danger weights
	for i in NUM_RAYS:
		if danger[i] > 0.0:
			interest[i] -= danger[i] * DANGER_PUSH_FACTOR # This number dictates how hard a danger vector 'pushes away'
	
	# Adjust chosen direction by summing all rays * interest weights
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
