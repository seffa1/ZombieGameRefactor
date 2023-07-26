extends "res://Libraries/state_machine.gd"

"""
This is the state for the 'upper body' of the player.
While the other state machine for the 'lower body' deals
which movement, this one deals will all the actions the player
can perform.
"""

func _ready():
	super()
	states_map = {
		"idle": $Idle,
		"shoot": $Shoot,
		"reload": $Reload,
		"charge_throw": $ChargeThrow,
		"throw": $Throw,
		"melee": $Melee,
		"die": $Die
	}

func _change_state(state_name):
	"""
	The base state_machine interface this node extends does most of the work
	"""
	if not _active:
		return
	# If we want to add state to the state-queue
	if state_name in ["shoot", "die", "melee"]:
		states_stack.push_front(states_map[state_name])
	# Otherwise the base statemachine will just switch to the new state
	super(state_name)

func _input(event):
	"""
	Here we only handle input that can interrupt states, shooting in this case
	otherwise we let the state node handle it
	"""
	if not _active:
		return

	current_state.handle_input(event)
