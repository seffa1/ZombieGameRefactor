extends RigidBody2D

"""
When thrown, the poilce gives this object an impulse and calls the 'throw' method.

Needs an VFX scene to spawn when it dies. The VFX scene should handle hit boxes as well.
"""

@onready var explode_timer: Timer = $ExplodeTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio = $AudioStreamPlayer2D

@export var free_time: float
@export var explosion_to_spawn: PackedScene
@export var ground_hit_audio: AudioStream

# if we are throwing multiple equipment out before one explodes,
#  this helps us track which one has NOT been thrown already in the groups
var has_been_thrown: bool = false  

func _ready():
	# Star the throw animation on the equipment
	throw()


func throw():
	"""
	The hang time is determined by how long the player action state charged the grenade. It will
	determine how high in the air the grenade goes.
	"""
	# Set values
	has_been_thrown = true

	# Start the throwing animation
	animation_player.play("throw")
	explode_timer.start(free_time)

func _on_throw_animation_compete():
	audio.stream = ground_hit_audio
	audio.play()
	

func _on_timer_timeout():
	# Spawn effect and get removed
	var explosion = explosion_to_spawn.instantiate()
	explosion.global_position = global_position
	explosion.rotation = rotation
	explosion.initialize([7, 8, 9])
	ObjectRegistry.register_effect(explosion)
	queue_free()


