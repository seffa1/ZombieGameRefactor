extends "res://Libraries/state.gd"

# Since the idle is the state on load, we cant reference the animation player from the owner
# because it wont be ready yet
@onready var animation_player = $"../../AnimationPlayer"

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


