"""
Base interface for a generic state machine
It handles initializing, setting the machine active or not
delegating _physics_process, _input calls to the State nodes,
and changing the current/active state.
See the PlayerV2 scene for an example on how to use it.
Also uses a state stack/'push down automoton'/state queue.
"""
extends Node

signal state_changed(state_stack)

"""
You must set a starting node from the inspector or on
the node that inherits from this state machine interface
If you don't the game will crash (on purpose, so you won't 
forget to initialize the state machine)
"""
@export var START_STATE: NodePath
var states_map = {}

var states_stack = []
var current_state = null
var _active = false:
	set(value):
		_active = value
		set_physics_process(value)
		set_process_input(value)
		if not _active:
			states_stack = []
			current_state = null

func _ready():
	assert(get_node(START_STATE), "You forgot to set the start state.")
	
	for child in get_children():
		child.finished.connect(_change_state)
	initialize(START_STATE)

func initialize(start_state):
	_active = true
	states_stack.push_front(get_node(start_state))
	current_state = states_stack[0]
	current_state.enter()
	emit_signal("state_changed", states_stack)

func reset_stack():
	"""
	Called by player state machine action reload state to be able to cancel other states
	After the reload state exist, it resets the state back to idle.
	"""
	states_stack.clear() 
	states_stack.push_front(get_node(START_STATE))

func _input(event):
	if not _active:
		return
	current_state.handle_input(event)

func _physics_process(delta):
	if not _active:
		return
	current_state.update(delta)

func _on_animation_finished(anim_name):
	if not _active:
		return
	current_state._on_animation_finished(anim_name)

func _change_state(state_name):
	if not _active:
		return
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]
	
	current_state = states_stack[0]
	emit_signal("state_changed", states_stack)

	
	# We don"t want to reinitialize the state if we"re going back to the previous state
	## At the moment it makes sense to reinitialize when going to 'previous' state
#	if state_name != "previous":
	current_state.enter()
