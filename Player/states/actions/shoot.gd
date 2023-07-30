extends "res://Libraries/state.gd"

@onready var weapon_manager: Node = owner.find_child("WeaponManager")
var weapon_object
var fire_type

func enter():
	# Get the gun and its fire type, the type determines how we exit the state
	if !weapon_manager.has_a_gun():
		emit_signal("finished", "idle")
		return
	weapon_object = weapon_manager.get_equipped_gun()
	fire_type = weapon_object.fire_type
	
	# Make sure the gun can fire
	if !_able_to_shoot():
		emit_signal("finished", "idle")
		return

	# shoot the gun and play the animation
	weapon_object.shoot()

	# Play the shoot animation specific to the given weapon
	var animation_name = _get_animation_name(weapon_object)
	
	# TODO - Until the fire rate is able to dynamically change the speed of the animations
	# we have to make sure the fire rate is shorter than the animation since the animation
	# is controlling the state in automatic firing mode
	assert(owner.animation_player.get_animation(animation_name).length > weapon_object.fire_rate, "Gun fire rate is faster than the shoot animation!")
	owner.animation_player.stop()
	owner.animation_player.play(animation_name)

func _on_shoot_animation_finished():
	"""
	Called by the animation player. When the shooting animation is complete. 
	Checks if we need to exit the state (single fire/burst fire) or,for an automatic gun, 
	replay the animation and stay in the shoot state
	"""
	
	if fire_type == "automatic":
		# check if shoot Input is still held and the gun is able to shoot
		if !Input.is_action_pressed("shoot"):
			emit_signal("finished", "idle")
			return
		if !_able_to_shoot():
			# TODO - if the gun's fire rate is slower than the animation, then we exit state
			# but that is not a good way to do it. The animation should change speeds to
			# match the fire rate.
			emit_signal("finished", "idle")
			return
		# re-enter the fire state
		enter()
	else:
		# single / burst fire weapons play one animation and go back to idle state until shoot is called again
		emit_signal("finished", "idle")
		return

func _get_animation_name(weapon_object) -> String:
	return Globals.GUN_INDEX[weapon_object.WEAPON_NAME]["shoot_animation"]

func _able_to_shoot() -> bool:
	return weapon_manager.has_a_gun() and weapon_object.can_shoot()

# Clean up the state. Reinitialize values like a timer
func exit():
	owner.animation_player.stop()
	weapon_object = null
	fire_type = null
