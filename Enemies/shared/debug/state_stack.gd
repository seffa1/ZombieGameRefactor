extends Label


@export var state_machine: Node

func _ready():
	state_machine.state_changed.connect(_state_change)
	visible = false
	
func _state_change(statestack):
	text = statestack[0].name
