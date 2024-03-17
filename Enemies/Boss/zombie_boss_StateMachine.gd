extends "res://Libraries/state_machine.gd"

"""
This state machine handles player movement independant of the player's actions.
This way the legs can freely move / sprint / idle while the player shoots without
interuption.
"""

@onready var head_health_component: Node = %"HealthComponent - Head"

func _ready():
	super()
	states_map = {
		"seek_player": $SeekPlayer,
		"attack_player": $AttackPlayer,
		"flame_attack": $FlameAttack,
		"ranged_attack": $RangedAttack,
		"death": $Death,
		"roar": $Roar,
		"charge_player": $ChargePlayer,
		"head_attack": $HeadAttack
	}
	
	head_health_component.health_at_zero.connect(_on_head_health_at_zero)

func _on_head_health_at_zero():
	_change_state("death")

func _change_state(state_name):
	"""
	The base state_machine interface this node extends does most of the work
	"""
	if not _active:
		return
		
	if state_name in ["seek_player"]:
		reset_stack()
		
	# If we want to add state to the state-queue
	if state_name in ["die", "seek_player", "attack"]:
		states_stack.push_front(states_map[state_name])
	# Otherwise the base statemachine will just switch to the new state
	super(state_name)
