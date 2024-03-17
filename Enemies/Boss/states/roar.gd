extends "res://Libraries/state.gd"

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var velocity_component: Node = %VelocityComponent
@onready var health_component_head: Node = %"HealthComponent - Head"

func _ready():
	pass

func enter():
	animation_player.play("roar")


# Clean up the state. Reinitialize values like a timer
func exit():
	# Allows the head component to take damage
	health_component_head.invincible_mode = false

func update(delta):
	velocity_component.decelerate(delta)
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func _on_roar_animation_finished():
	emit_signal("finished", "charge_player")

func roar_shake():
	Events.emit_signal("shake_screen", 25, 2.0)
