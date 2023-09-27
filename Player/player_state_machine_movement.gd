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
	
	Events.player_dies.connect(_on_player_death)

func _on_player_death():
	_change_state("die")

func _change_state(state_name):
	"""
	The base state_machine interface this node extends does most of the work
	"""
	if not _active:
		return
	
	if state_name in ["idle"]:
		reset_stack()
		
	# If we want to add state to the state-queue
	if state_name in ["die", "move", "sprint"]:
		states_stack.push_front(states_map[state_name])
	# Otherwise the base statemachine will just switch to the new state
	super(state_name)
		

func _input(event):
	"""
	Here we only handle input that can interrupt states.
	otherwise we let the state node handle it
	"""
	if not _active:
		return
	current_state.handle_input(event)

