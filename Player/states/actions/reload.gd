extends "res://Libraries/state.gd"

@onready var weapon_manager: Node = owner.find_child("WeaponManager")
var weapon_object

# Initialize the state. E.g. change the animation
func enter():
	# TODO - since the statemachine is handling this state's entering, we may not need this all here
	
	# Check if we have a gun to reload
	if !weapon_manager.has_a_gun():
		emit_signal("finished", "idle")
		return
		
	# Get the gun
	weapon_object = weapon_manager.get_equipped_gun()
	
	# Check if we have ammo in reserve
	if weapon_object.bullet_reserve == 0:
		Events.emit_signal("player_log", "No ammo")
		emit_signal("finished", "idle")
		return
	
	# Check if the clip is already full
	if weapon_object.bullets_in_clip == weapon_object.clip_size:
		Events.emit_signal("player_log", "Magazine Full")
		emit_signal("finished", "idle")
		return
	
	# Play the reload animation
	owner.animation_player.stop()
	owner.animation_player.play(Globals.GUN_INDEX[weapon_object.WEAPON_NAME]["reload_animation"])

func _on_reload_animation_finished():
	weapon_object.reload()
	emit_signal("finished", "idle")
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	weapon_object = null

