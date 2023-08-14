extends "res://Libraries/state.gd"

# Since the idle is the state on load, we cant reference the animation player from the owner
# because it wont be ready yet
@onready var animation_player = $"../../AnimationPlayer"
@onready var weapon_manager = $"../../WeaponManager"

# Initialize the state. E.g. change the animation
func enter():
	animation_player.play("idle_pistol")

# Clean up the state. Reinitialize values like a timer
func exit():
	animation_player.stop()

func handle_input(event):
	return

func update(delta):
	if Input.is_action_just_pressed("shoot"):
		# Cannot shoot if player's action is sprinting
		if owner.state_machine_movement.states_stack[0] == owner.state_machine_movement.states_map["sprint"]:
			return
		emit_signal("finished", "shoot")
		return
		
	# Check for switching weapons
	if Input.is_action_just_pressed("next_weapon"):
		# only switch guns if we have at least two guns
		if !weapon_manager.has_two_guns():
			return
		weapon_manager.next_weapon()
		emit_signal("finished", "switch_weapons")
		return

	if Input.is_action_just_pressed("previous_weapon"):
		# only switch guns if we have at least two guns
		if !weapon_manager.has_two_guns():
			return
		weapon_manager.previous_weapon()
		emit_signal("finished", "switch_weapons")
		return
