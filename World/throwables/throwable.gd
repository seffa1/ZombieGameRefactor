extends RigidBody2D

"""
Base scene for objects the player gun throw like: grenades, molitovs, etc.
Spawned by the player's action state during the charge state.
When throws, the player gives this object an impulse and calls the 'throw' method.

Needs an VFX scene to spawn when it dies. The VFX scene should handle hit boxes as well.
"""

@onready var explode_timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var free_time: float
@export var VFX_to_spawn: PackedScene

# Dampening animation code - simulates 'hitting the ground' and sticking
@export var final_linear_damp_value: float = 3.0
@export var final_angular_damp_value: float = 3.0
@export var hang_time: float = 0.7  # how long the item is in the air (no damping) before it hits the ground
@export var tween_duration: float = 0.1 # once the item hits the ground, how fast it slows down

var player  # store a reference to player so they can get money back 

func throw(player: CharacterBody2D, hang_time):
	"""
	The hang time is determined by how long the player action state charged the grenade. It will
	determine how high in the air the grenade goes.
	"""
	player = player
	animation_player.play("throw")
	explode_timer.start(free_time)

func _on_throw_animation_complete():
	# Simulate ground friction
	var tween1 = get_tree().create_tween()
	tween1.tween_property(owner, "linear_damp", final_linear_damp_value, tween_duration)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(owner, "angular_damp", final_angular_damp_value, tween_duration)

func _on_timer_timeout():
	# Spawn effect and get removed
	var vfx = VFX_to_spawn.instantiate()
	vfx.global_position = global_position
	vfx.rotation = rotation
	vfx.player = player  # vfx will spawn hitboxes and give the player money for doing damage / getting kills
	Globals.ObjectRegistry.register_effect(vfx)
	queue_free()


