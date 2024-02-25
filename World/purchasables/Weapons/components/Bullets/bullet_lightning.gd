extends RayCast2D

@export_group('Lightning VFX config')
@export_range(0, 10) var flashes: int = 3
@export_range(0, 3.0, 0.1) var flash_time: float = 0.1
@export_range(0, 10) var bounces_max: int = 3

@export var lightning_arc_scene: PackedScene = preload("res://World/purchasables/Weapons/components/Bullets/LightningArc.tscn")

@export_group('Damage config')
@export var damage_per_second: float = 50.0
@export var electrocution_time: float = 5.0

@onready var jump_area = $JumpArea
@onready var hitbox_scene: PackedScene = preload("res://World/purchasables/Weapons/components/Bullets/HitBoxComponent-Lightning.tscn")

var target_point: Vector2 = Vector2.ZERO

func _ready():
	collide_with_areas = true

func _physics_process(delta):
	target_point = to_global(target_position)
	
	if is_colliding():
		target_point = get_collision_point()
		
	jump_area.global_position = target_point
	
func shoot():
	var _target_point = target_point

	# Could be the environment, or an enemy
	var _primary_body = get_collider()
	
	# Areas here are the conductable components
	var _secondary_bodies = jump_area.get_overlapping_areas()

	# So the primary body doesnt get hit twice since it will be inside the jump area already
	if _primary_body:
		_primary_body.electrocute(damage_per_second, electrocution_time)
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
			if is_instance_valid(_body):
				_body.electrocute(damage_per_second, electrocution_time)
			add_child(arc)
			# If the enemy is killed by the shot, we can't lookup their position
			if (is_instance_valid(_body)):
				arc.create(_start, _body.global_position)
				_start = _body.global_position

		# Make a one-shot timer and wait for it to finish.
		# await get_tree().create_timer(flash_time).timeout
