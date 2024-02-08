extends RayCast2D

@export_range(0, 10) var flashes: int = 3
@export_range(0, 3.0, 0.1) var flash_time: float = 0.1
@export_range(0, 10) var bounces_max: int = 3

@export var lightning_arc_scene: PackedScene = preload("res://World/purchasables/Weapons/components/Bullets/LightningArc.tscn")

@onready var jump_area = $JumpArea

var target_point: Vector2 = Vector2.ZERO

func _physics_process(delta):
	target_point = to_global(target_position)
	
	if is_colliding():
		target_point = get_collision_point()
		
	jump_area.global_position = target_point
	
func shoot():
	var _target_point = target_point
	
	# Could be the environment, or an enemy
	var _primary_body = get_collider()
	var _secondary_bodies = jump_area.get_overlapping_bodies()
	
	# So the primary body doesnt get hit twice since it will be inside the jump area already
	if _primary_body:
		_secondary_bodies.erase(_primary_body)
		_target_point = _primary_body.global_position
	
	# Create the lightning bolts going to the target position
	for flash in range(flashes):
		var _start = global_position
		var arc = lightning_arc_scene.instantiate()
		add_child(arc)
		arc.create(_start, target_point)
		_start = _target_point
		
		# For each lightning bolt, create the bolt that jumps to a secondary body
		for _i in range(min(bounces_max, _secondary_bodies.size())):
			var _body = _secondary_bodies[_i]
			arc = lightning_arc_scene.instantiate()
			add_child(arc)
			arc.create(_start, _body.global_position)
			_start = _target_point

		# Make a one-shot timer and wait for it to finish.
		await get_tree().create_timer(flash_time).timeout
