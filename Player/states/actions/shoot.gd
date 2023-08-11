extends "res://Libraries/state.gd"

@onready var weapon_manager: Node = $"../../WeaponManager"
var weapon_object
var fire_type

func enter():
	# Get the gun and its fire type, the type determines how we exit the state
	if !weapon_manager.has_a_gun():
		emit_signal("finished", "idle")
		return
	weapon_object = weapon_manager.get_equipped_gun()
	fire_type = weapon_object.fire_type
	
	# Handle single fire here, and automatic in _process
	if fire_type == "single_fire":
	
		# Make sure the gun can fire
		if !_able_to_shoot():
			emit_signal("finished", "idle")
			return

		# shoot the gun and play the animation
		weapon_object.shoot()
		var animation_name = Globals.GUN_INDEX[weapon_object.WEAPON_NAME]["shoot_animation"]
		owner.animation_player.play(animation_name)

func _able_to_shoot() -> bool:
	return weapon_manager.has_a_gun() and weapon_object.can_shoot()

func _on_shoot_animation_finished():
	"""
	Handle singefire/burst fire state
	"""
	# Just in case we still have call method track in the animation for testing purposes
	if fire_type == "automatic":
		return

	# single / burst fire weapons play one animation and go back to idle state until shoot is called again
	emit_signal("finished", "idle")
	return

func _process(delta):
	"""
	Handling the automatic weapon shooting state
	"""
	await enter  # Dont process until the enter function finishes
	
	if !fire_type == "automatic":
		return
	
	# check if shoot Input is still held and the gun is able to shoot
	if !Input.is_action_pressed("shoot"):
		emit_signal("finished", "idle")
		return
	
	# Check that theres still bullets in the clip
	if weapon_object.bullets_in_clip == 0:
		emit_signal("finished", "idle")
		return
	
	# If the gun's fire rate time is stopped, then shoot the gun
	if weapon_object.fire_timer.is_stopped():
		# Fire gun and play animation
		weapon_object.shoot()
		var animation_name = Globals.GUN_INDEX[weapon_object.WEAPON_NAME]["shoot_animation"]
		owner.animation_player.play(animation_name)

# Clean up the state. Reinitialize values like a timer
func exit():
	owner.animation_player.stop()
	weapon_object = null
	fire_type = null
