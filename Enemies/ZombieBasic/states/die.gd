extends "res://Libraries/state.gd"

@export var death_money_reward: int = 100
@onready var gore_vfx = $"../../GoreVFX"

# Initialize the state. E.g. change the animation
func enter():
	# Give player money
	Events.emit_signal("give_player_money", death_money_reward)
	
	# TODO - death vfx
	gore_vfx.zombie_death()
	
	# signal for the zombie manager
	Events.emit_signal("zombie_death", owner)
	
	# die
	owner.queue_free()
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func update(delta):
	# TODO - Movement code
	return

func _on_animation_finished(anim_name):
	return

