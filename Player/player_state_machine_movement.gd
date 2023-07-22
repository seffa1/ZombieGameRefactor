extends "res://Libraries/state_machine.gd"

"""
This state machine handles player movement independant of the player's actions.
This way the legs can freely move / sprint / idle while the player shoots without
interuption.
"""


func _ready():
	super()
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"sprint": $Sprint,
		"die": $Die
	}

func _change_state(state_name):
	"""
	The base state_machine interface this node extends does most of the work
	"""
	print("Player movement state changed: " + str(state_name))
	if not _active:
		return
	# If we want to add state to the state-queue
	if state_name in ["die", "move"]:
		states_stack.push_front(states_map[state_name])
	super(state_name)

func _input(event):
	"""
	Here we only handle input that can interrupt states.
	otherwise we let the state node handle it
	"""
	if not _active:
		return
	current_state.handle_input(event)

