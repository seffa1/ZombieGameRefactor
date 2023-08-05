extends Node2D

"""
Path finding logic which updates the velocity component each tick to go towards
the target position (A*), and then calculates any avoidance (context-based-steering). 
The target position is supplied by the owner.
"""
# CONTEXT BASED STEERING STUFF ----------------------
var DANGER_DOT_VALUE = .7  # danger vector dot the target direction that is ignored
var ZOMBIE_DANGER_WEIGHT = .7  # How much zombies avoid each other
var ZOMBIE_DANGER_OUTSIDE_WEIGHT = .1  # How much zombies avoid each other when outside
var targetPosition
var steer_force = .1
var look_ahead = 150
var num_rays = 9  # Make this an odd number
var ray_directions = []
var interest = []
var danger = []
var chosen_dir = Vector2.ZERO
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var desired_velocity = Vector2.ZERO
var wallBounce = false
@export var draw_lines: bool = true
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
	
	movement_direction = to_local(nagivation_agent.get_next_path_position()).normalized()
	velocity_component.accelerate_in_direction(movement_direction)
	
	# Context based steering
#	TODO - turn these on and get it to work with the drawing BEFORE having it update velocity
	set_interest(velocity_component.velocity)
	set_danger()
	choose_direction()
	


# CONTEXT BASED STEERING STUFF ----------------------
func _ready():
	# Setup the context array
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	# creates and evenly rotates unit vectors and adds them to ray_directions
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)

func set_interest(path_direction):
	# only use vectors with position dot products (in the same direction)
	for i in num_rays:
		var d = ray_directions[i].rotated(rotation).dot(path_direction)
#		var d = ray_directions[i].dot(path_direction)
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
	for i in num_rays:
		var query = PhysicsRayQueryParameters2D.create(position, position + ray_directions[i].rotated(rotation) * look_ahead, 4294967295, [self])
		var collision = get_world_2d().direct_space_state.intersect_ray(query)

	# Levels of danger:
	# When populating the danger array, don’t just use 0 or 1, but instead calculate a danger “score” 
	# based on the distance of the object. 
	# Then subtract that amount from the interest rather than removing it. 
	# Far away objects will have a small impact while close ones will have more.
		if !collision:
			print("no collision: " + str(i))
			danger[i] = 0
		else:
			# TODO DEBUGGING:
			# check what the rays are colliding with
			
			print("COLLISION " + str(i))
			var dangerDistance = (collision.position - global_position).length()
			# the closer something is, the larger the danger weight
			var dangerWeight =  1 - dangerDistance / look_ahead
#			print(dangerWeight)
			# This lessens the danger amount if its colliding with a zombie instead
			# of a wall
			
			# TODO - check using groups instead
			if collision["collider"] in get_tree().get_nodes_in_group("Zombies"):
				dangerWeight *= ZOMBIE_DANGER_WEIGHT
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
	for i in num_rays:
		if danger[i] > 0.0:
#			interest[i] = 0.0
			# This number dictates how hard a danger vector "pushes" away from a wall
			var magicDangerNumber = 2
			interest[i] -= danger[i] * magicDangerNumber
	# Choose direction based on remaining interest
	chosen_dir = Vector2.ZERO.rotated(rotation)
	
	for i in num_rays:
		# negative values should effect the dir as much as positive numbers
		var magicDirectionNumber = 1
		if interest[i] < 0:
			chosen_dir += ray_directions[i] *  interest[i] * magicDirectionNumber
		else:
			chosen_dir += ray_directions[i] * interest[i]
			
	chosen_dir = chosen_dir.normalized()
	print(chosen_dir)
	velocity_component.accelerate_in_direction(chosen_dir)


func _draw():
	if draw_lines:
		draw_line(Vector2.ZERO, chosen_dir.normalized()*200, Color(0,0,0), 1, true)

		# Draw the interest vectors
		for i in num_rays:
			if interest[i] == null:
				return
			if interest[i] > 0:
				draw_line(Vector2.ZERO, ray_directions[i].normalized()*look_ahead*interest[i] , Color(0,255,0), 3, true)
			elif interest[i] == 0:
				# Red vectors are not pointing forwards
				draw_line(Vector2.ZERO, ray_directions[i].normalized()*look_ahead*0.1 , Color(255,0,0), 3, true)
			elif interest[i] < 0:
				draw_line(Vector2.ZERO, ray_directions[i].normalized()*look_ahead *-interest[i], Color(0,0,255), 3, true)


## ORIGINAL CODE FROM PREVIOUS GAME
#func seekTarget(targetPosition, delta):
#	""" Uses ray casts to navigate the zombie towards a target position more natually. """
#	if not targetPosition:
#		return
#	if closeToTarget():
#		return
#
#	# Context based steering
#	set_interest(targetPosition)
#	set_danger()
#	choose_direction()
#
#	desired_velocity = chosen_dir.rotated(rotation) * walkingSpeed
##	velocity = velocity.linear_interpolate(desired_velocity, steer_force)
##	rotation = velocity.angle()
#
#	velocity = desired_velocity
#
#	# This feels wrong
#	# Update the rotation of the children
#	$Sprite.rotation = lerp_angle($Sprite.rotation, velocity.angle() - 90, steer_force)
#	$HurtBox.rotation = lerp_angle($HurtBox.rotation, velocity.angle(), steer_force)
#	$PlayerDetector.rotation = lerp_angle($PlayerDetector.rotation, velocity.angle(), steer_force)
#	$WindowDetector.rotation = lerp_angle($WindowDetector.rotation, velocity.angle(), steer_force)
#
#	# I have no idea why i am not able to rotate the entire node
##	rotation = lerp_angle(rotation, velocity.angle(), steer_force)
#
#	move_and_slide(velocity)

#func set_interest(targetPosition):
#
#	var path_direction = (targetPosition - global_position).normalized()
#	# only use vectors with position dot products (in the same direction)
#	for i in num_rays:
#		var d = ray_directions[i].rotated(rotation).dot(path_direction)
##		var d = ray_directions[i].dot(path_direction)
#		# ignore vectors which are not pointing in the forward direction
#		interest[i] = max(0, d)
##		interest[i] = d
#	# used for drawing
#	update()

#func set_danger():
#	# Cast rays to find danger directions
#	# Gets access to the physics space
#	var space_state = get_world_2d().direct_space_state
#	for i in num_rays:
#		var result = space_state.intersect_ray(position,
#			position + ray_directions[i].rotated(rotation) * look_ahead,
#			[self])
## Levels of danger:
## When populating the danger array, don’t just use 0 or 1, but instead calculate a danger “score” 
## based on the distance of the object. 
## Then subtract that amount from the interest rather than removing it. 
## Far away objects will have a small impact while close ones will have more.
#		if result:
#			var dangerDistance = (result.position - global_position).length()
#			# the closer something is, the larger the danger weight
#			var dangerWeight =  1 - dangerDistance / look_ahead
##			print(dangerWeight)
#			# This lessens the danger amount if its colliding with a zombie instead
#			# of a wall
#			if result["collider"].get_filename() == "res://zombie/Zombie.tscn":
#				if state == "seek_window":
#					dangerWeight *= ZOMBIE_DANGER_OUTSIDE_WEIGHT  # trying to prevent wall bounces off eachother when they havent even got inside yet
#				else:
#					dangerWeight *= ZOMBIE_DANGER_WEIGHT
#
#			# If the danger ray is in the same direction as the target, lessen its effect
#			if interest[i] > DANGER_DOT_VALUE:
#				dangerWeight = 0
#			danger[i] = dangerWeight
#		else:
#			danger[i] = 0

#func choose_direction():
#	# Dont update the direction if we are doing a wall bounce
#	# Only on if WALL_BOUNCE_ENABLED is true
#	if wallBounce:
#		return
#	# Eliminate interest in slots with danger
#	# Avoidance
#	# Rather than a danger item canceling the interest, it could add to the interest in the opposite direction.
#	for i in num_rays:
#		if danger[i] > 0.0:
##			interest[i] = 0.0
#			# This number dictates how hard a danger vector "pushes" away from a wall
#			var magicDangerNumber = 2
#			interest[i] -= danger[i] * magicDangerNumber
#	# Choose direction based on remaining interest
#	chosen_dir = Vector2.ZERO.rotated(rotation)
#	for i in num_rays:
#		# negative values should effect the dir as much as positive numbers
#		var magicDirectionNumber = 1
#		if interest[i] < 0:
#			chosen_dir += ray_directions[i] *  interest[i] * magicDirectionNumber
#		else:
#			chosen_dir += ray_directions[i] * interest[i]
#
#	chosen_dir = chosen_dir.normalized()
#
#	# This happens if our target is on the other side of a wall
#	# so we 'push' him away from the wall for a second
#	# only works if WALL_BOUNCE_ENABLED is true
#	var targetVector = (targetPosition - global_position).normalized()
#	if chosen_dir.dot(targetVector) < 0:
##		print("Chosen direction away from target")
##		print(ray_directions)
##		print(danger)
##		print(interest)
#		chosen_dir = targetVector.rotated(90)
#		if not wallBounce and WALL_BOUNCE_ENABLED:
#			#print("wall bounce")
#			wallBounce = true
#			$WallBounceTimer.wait_time = WALL_BOUNCE_TIMER
#			$WallBounceTimer.start()

# ---------------------------------------------------
