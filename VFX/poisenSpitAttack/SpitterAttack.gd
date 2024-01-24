extends CharacterBody2D

@onready var player_hit_box = $PlayerHitBox

var speed: int = 600
var direction: Vector2

func _ready():
	$AnimationPlayer.play("spit")

# Position and rotation are set by the zombie spitter
func _physics_process(delta: float) -> void:
	var motion_vector = speed * direction.normalized() * delta
	var collision := move_and_collide(motion_vector)
	
	# Check for collision with the environment
	if collision:
		spawn_spit_pool()
		queue_free()

func spawn_spit_pool():
	# TODO
	return

# If it hist the player
func _on_player_hit_box_area_entered(area):
	spawn_spit_pool()
	queue_free()
