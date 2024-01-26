extends "res://Libraries/state.gd"

@onready var animation_player = $"../../AnimationPlayer"

func enter():
	animation_player.play("zombie_attack_explode")

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func update(delta):
	owner.velocity_component.decelerate(delta)
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()


func _on_animation_finished(anim_name):
	emit_signal("finished", "explode")
	
