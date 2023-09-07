extends RigidBody2D

"""
Base scene for objects the player gun throw like: grenades, molitovs, etc.
Spawned by the player's action state during the charge state.
When throws, the player gives this object an impulse and calls the 'throw' method.

Needs an VFX scene to spawn when it dies. The VFX scene should handle hit boxes as well.
"""

@onready var explode_timer: Timer = $ExplodeTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var free_time: float
@export var explosion_to_spawn: PackedScene

var player  # store a reference to player so they can get money back
var has_been_thrown: bool = false  # if we are throwing an equipment which already an another instace that was throw, this helps us track which one has NOT been thrown already in the groups

func _ready():
	# Star the throw animation on the equipment
	print("THROWING")
	throw()


func throw():
	"""
	The hang time is determined by how long the player action state charged the grenade. It will
	determine how high in the air the grenade goes.
	"""
	# Set values
	has_been_thrown = true
	player = player
	# Start the throwing animation
	animation_player.play("throw")
	explode_timer.start(free_time)

func _on_timer_timeout():
	# Spawn effect and get removed
	var explosion = explosion_to_spawn.instantiate()
	explosion.global_position = global_position
	explosion.rotation = rotation
#	explosion.set_player(player) # vfx will spawn hitboxes and give the player money for doing damage / getting kills
	ObjectRegistry.register_effect(explosion)
	queue_free()


