extends "res://Libraries/state.gd"

@export var death_money_reward: int = 100
@onready var gore_vfx = $"../../GoreVFX"
@onready var animation_player = $"../../AnimationPlayer"

# Initialize the state. E.g. change the animation
func enter():
	# disable hurt box
	owner.hurt_box_component.monitorable = false
	owner.hurt_box_component.monitoring = false
	animation_player.play("zombie_death")
	# Give player money
	Events.emit_signal("give_player_money", death_money_reward)

func _on_death_animation_finished():
	# signal for the zombie manager
	Events.emit_signal("zombie_death", owner)
	gore_vfx.zombie_death()
	owner.queue_free()
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func update(delta):
	# Movement code
	owner.velocity_component.decelerate(delta)
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	return

func _on_animation_finished(anim_name):
	return

