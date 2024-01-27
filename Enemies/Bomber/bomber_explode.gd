extends "res://Libraries/state.gd"

@onready var animation_player = $"../../AnimationPlayer"

@onready var explosion = preload("res://VFX/explosions/Explosion_damagePlayer.tscn")
@onready var gore_vfx = $"../../GoreVFX"
@onready var hit_box = $"../../PlayerHitBox"


func enter():
	hit_box.monitoring = false
	hit_box.monitorable = false
	explode()


# Clean up the state. Reinitialize values like a timer
func exit():
	return

func update(delta):
	return

func explode():
	# Explosion vfx
	var explosionObject = explosion.instantiate()
	explosionObject.global_position = owner.global_position
	explosionObject.initialize([0, 1, 3, 5])
	
	ObjectRegistry.register_effect(explosionObject)


	# Gore vfx
	gore_vfx.explosion_death(owner.global_position, owner.global_position)
	Events.emit_signal("zombie_death", owner)
	owner.queue_free()


