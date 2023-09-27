extends "res://Libraries/state_machine.gd"

"""
This is the state for the 'upper body' of the player.
While the other state machine for the 'lower body' deals
which movement, this one deals will all the actions the player
can perform.
"""

@onready var weapon_manager = owner.find_child("WeaponManager")

func _ready():
	super()
	states_map = {
		"idle": $Idle,
		"shoot": $Shoot,
		"reload": $Reload,
		"switch_weapons": $SwitchWeapons,
		"buy_weapon": $BuyWeapon,
		"lower_weapon": $LowerWeapon,
		"sprint": $Sprint,
		"charge_throw": $ChargeThrow,
		"throw": $Throw,
		"melee": $Melee,
		"die": $Die,
	}
	
	Events.player_buy_weapon.connect(_on_player_buy_weapon)
	Events.player_sprinting.connect(_on_player_sprinting)
	Events.lower_weapon.connect(_on_player_lower_weapon)
	Events.player_switch_weapons.connect(_on_player_switch_weapons) # called via weapon manager when a gun is removed via pack a punch
	Events.player_action_idle.connect(_on_player_action_idle)
	Events.player_dies.connect(_on_player_death)

func _on_player_death():
	_change_state("die")
	
func _on_player_action_idle():
	_change_state("idle")

func _on_player_switch_weapons():
	_change_state("switch_weapons")

func _on_player_lower_weapon():
	if !weapon_manager.has_a_gun():
		return
	_change_state("lower_weapon")

func _on_player_buy_weapon():
	_change_state("buy_weapon")

func _on_player_sprinting():
	_change_state("sprint")

func _change_state(state_name):
	"""
	The base state_machine interface this node extends does most of the work
	"""
	if not _active:
		return
	if state_name in ["idle"]:
		reset_stack()

	# If we want to add state to the state-queue
	if state_name in ["die", "melee"]:
		states_stack.push_front(states_map[state_name])
	# Otherwise the base statemachine will just switch to the new state
	super(state_name)

func _input(event):
	"""
	Here we only handle input that can interrupt states.
	"""
	if not _active:
		return
		
	if event.is_action_pressed("reload"):
		# Dont interrupt these states
		if current_state == $Reload:
			return
		if current_state == $SwitchWeapons or current_state == $BuyWeapon:
			return
		if current_state == $LowerWeapon:
			return
		if current_state == $ChargeThrow or current_state == $Throw:
			return

		# Dont interupt state if we dont have ammo or clip is already full
		if !weapon_manager.has_a_gun():
			Events.emit_signal("player_log", "No gun")
			return
		var weapon_object = weapon_manager.get_equipped_gun()
		if weapon_object.bullet_reserve == 0:
			weapon_object.play_no_ammo_sound()
			Events.emit_signal("player_log", "No ammo")
			return
		if weapon_object.bullets_in_clip == weapon_object.clip_size:
			Events.emit_signal("player_log", "Magazine Full")
			return

		_change_state("reload")
		return
		
	current_state.handle_input(event)

