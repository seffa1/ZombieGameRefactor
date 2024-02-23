extends "res://Libraries/state_machine.gd"

"""
This state machine handles player movement independant of the player's actions.
This way the legs can freely move / sprint / idle while the player shoots without
interuption.
"""

@onready var head_health_component = $"../HealthComponents/HealthComponent - Head"
@onready var freezeable_component: Node2D = %FreezableComponent

func _ready():
	super()
	states_map = {
		"seek_window": $SeekWindow,
		"seek_player": $SeekPlayer,
		"seek_inside": $SeekInside,
		"attack_player": $AttackPlayer,
		"break_window": $BreakWindow,
		"attack_player_through_window": $AttackPlayerThroughWindow,
		"die": $Die,
		"stand_still": $StandStill,
		"headless_death": $HeadlessDeath,
		"frozen": $Frozen
	}
	
	head_health_component.health_at_zero.connect(_on_head_destroyed)
	freezeable_component.frozen.connect(_on_frozen)

func _on_head_destroyed():
	_change_state("headless_death")
	
func _on_frozen(is_frozen: bool):
	if is_frozen and states_stack[0] != $Frozen and states_stack[0] != $HeadlessDeath:
		_change_state("frozen")
	if !is_frozen and states_stack[0] == $Frozen:
		_change_state("previous")

func _change_state(state_name):
	"""
	The base state_machine interface this node extends does most of the work
	"""
	if not _active:
		return
		
	if state_name in ["seek_player"]:
		reset_stack()
		
	# If we want to add state to the state-queue
	if state_name in ["die", "seek_player", "attack", "break_window", "frozen"]:
		states_stack.push_front(states_map[state_name])
	# Otherwise the base statemachine will just switch to the new state
	super(state_name)


