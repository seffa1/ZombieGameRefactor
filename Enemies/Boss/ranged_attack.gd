extends "res://Libraries/state.gd"

@onready var velocity_component: Node = %VelocityComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func enter():
	animation_player.play("spit_attack")

# Clean up the state. Reinitialize values like a timer
func exit():
	pass

func update(delta):
	velocity_component.decelerate(delta)
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func _on_attack_animation_complete():
	emit_signal("finished", "seek_player")
