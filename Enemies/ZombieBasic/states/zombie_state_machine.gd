extends "res://Libraries/state_machine.gd"

"""
This state machine handles player movement independant of the player's actions.
This way the legs can freely move / sprint / idle while the player shoots without
interuption.
"""


func _ready():
	print("State machine ready")
	super()
	states_map = {
		"seek_window": $SeekWindow,
		"seek_player": $SeekPlayer,
		"attack_player": $AttackPlayer,
		"break_window": $BreakWindow,
		"attack_player_through_window": $AttackPlayerThroughWindow,
		"die": $Die
	}

func _change_state(state_name):
	"""
	The base state_machine interface this node extends does most of the work
	"""
	if not _active:
		return
		
	if state_name in ["seek_player"]:
		reset_stack()
		
	# If we want to add state to the state-queue
	if state_name in ["die", "seek_player", "attack", "break_window"]:
		states_stack.push_front(states_map[state_name])
	# Otherwise the base statemachine will just switch to the new state
	super(state_name)


