extends "res://Libraries/state_machine.gd"

"""
This state machine handles player movement independant of the player's actions.
This way the legs can freely move / sprint / idle while the player shoots without
interuption.
"""

@onready var head_health_component = $"../HealthComponents/HealthComponent - Head"
@onready var freezeable_component: Node2D = %FreezableComponent
@onready var conductable_component: Area2D = %ConductableComponent

func _ready():
	super()
	states_map = {
		"seek_player": $SeekPlayer,
		"attack_player": $AttackPlayer,
		"attack_player_spit": $AttackPlayer_Spit,
		"headless_death": $HeadlessDeath,
		"frozen": $Frozen,
		"electrocuted": $Electrocuted,
	}
	
	head_health_component.health_at_zero.connect(_on_head_destroyed)
	freezeable_component.frozen.connect(_on_frozen)
	conductable_component.electrocuted.connect(_on_electrocuted)

func _on_head_destroyed():
	match head_health_component.last_damage_source:
		# TODO
		# fire
		# electric
		# explosive
		_:
			_change_state("headless_death")
			
func _on_electrocuted(is_electrocuted: bool):
	if is_electrocuted and states_stack[0] != $HeadlessDeath and states_stack[0] != $Electrocuted:
		_change_state("electrocuted")
	if !is_electrocuted and states_stack[0] == $Electrocuted:
		_change_state("previous")

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
	if state_name in ["die", "seek_player", "attack", "break_window", "frozen", "electrocuted"]:
		states_stack.push_front(states_map[state_name])
	# Otherwise the base statemachine will just switch to the new state
	super(state_name)


