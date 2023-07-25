extends "res://Libraries/state.gd"

@onready var weapon_container: Node = owner.find_child("WeaponContainer")
var weapon_object
var fire_type


# Initialize the state. E.g. change the animation
func enter():
	
	# check if we have a gun to shoot
	if !weapon_container.has_a_gun():
		emit_signal("finished", "previous")
		return
	weapon_object = weapon_container.get_equipped_gun()
	
	# check if the gun is able to shoot
	if !weapon_object.can_shoot():
		emit_signal("finished", "previous")
		return
	
	# get the fire type, this will determine how we exit the state
	fire_type = weapon_object.fire_type
	
	# shoot the gun
	print("Shooting gun")
	weapon_object.shoot()
	
	# TODO - player the shoot animation
	emit_signal("finished", "previous") # DELETE THIS - temp until we get animations

func update(delta):
	return

func _on_animation_finished(anim_name):
	"""
	When the initial shooting animation is complete:
		If single fire / burst -> go back to idle
		If automatic:
			if ammo == 0 -> go back to idle
			if Input.is_action_pressed('shoot) -> shoot gun and play the animation again
	"""
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return
