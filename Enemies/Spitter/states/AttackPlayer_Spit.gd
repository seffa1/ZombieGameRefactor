extends "res://Libraries/state.gd"

"""
If a zombie is outside and within reach of a window, do break window animation.
"""

var spit_scene = "res://VFX/poisenSpitAttack/SpitterAttack.tscn"


# Initialize the state. E.g. change the animation
func enter():
	owner.animation_player.play("zombie_attack_spit")


# Clean up the state. Reinitialize values like a timer
func exit():
	owner.animation_player.stop()

func update(delta):
	# movement
	owner.velocity_component.decelerate(delta)
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	
func shoot_spit():
	# Spawn spit
	var spit_object = spit_scene.instantiate()
	spit_object.global_position = owner.global_position
	spit_object.rotation = owner.rotation
	ObjectRegistry.register_effect(spit_object)
	
	# TODO - change state back to 'seek player'

