@tool
extends Panel

func _ready():
	set_as_top_level(true)
	visible = Globals.debug_on

func _on_state_machine_movement_state_changed(states_stack):
	var states_names = ''
	var numbers = ''
	var index = 0
	for state in states_stack:
		states_names += state.get_name() + '\n'
		numbers += str(index) + '\n'
		index += 1

	$States.text = states_names
	$Numbers.text = numbers
	
func _on_state_machine_action_state_changed(states_stack):
	var states_names = ''
	var numbers = ''
	var index = 0
	for state in states_stack:
		states_names += state.get_name() + '\n'
		numbers += str(index) + '\n'
		index += 1

	$States.text = states_names
	$Numbers.text = numbers
