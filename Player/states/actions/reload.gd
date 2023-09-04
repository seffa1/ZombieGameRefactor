extends "res://Libraries/state.gd"

@onready var weapon_manager: Node = owner.find_child("WeaponManager")
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var has_quick_reload: bool = false  # set by player perk manager when they get quick reload perk

var weapon_object


# Initialize the state. E.g. change the animation
func enter():
	"""
	The state machine triggers this state's entrance. It checks that we have a gun, 
	it has reserve ammo, and that the magazine is not already full. The state machine
	does this because reloading is meant to cancel other states.
	"""
	# Get the gun
	weapon_object = weapon_manager.get_equipped_gun()

	# Play the reload animation
	weapon_object.start_reload()
	
	# Double reload speed if we have quick reload perk
	if has_quick_reload:
		animation_player.speed_scale = 2.0
	else:
		animation_player.speed_scale = 1.0
	
	# TODO - factor in gun reload speed as well
	
	animation_player.play(Globals.GUN_INDEX[weapon_object.WEAPON_NAME]["reload_animation"])

func _on_reload_animation_finished():
	weapon_object.finish_reload()
	emit_signal("finished", "idle")
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	animation_player.stop()
	weapon_object = null

func update(_delta):
	return
func handle_input(_event):
	return
