extends "res://Libraries/state_machine.gd"

"""
This is the state for the 'upper body' of the player.
While the other state machine for the 'lower body' deals
which movement, this one deals will all the actions the player
can perform.
"""

func _ready():
	states_map = {
		"idle": $Idle,
		"shoot": $Shoot,
		"chargeThrow": $ChargeThrow,
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
	if state_name in ["shoot", "die"]:
		states_stack.push_front(states_map[state_name])

func _input(event):
	"""
	Here we only handle input that can interrupt states, shooting in this case
	otherwise we let the state node handle it
	"""
	if event.is_action_pressed("shoot"):
		if current_state == $Shoot:
			return
		_change_state("shoot")
		return
	if current_state:
		current_state.handle_input(event)
