extends Node2D

@onready var stamina_component = $"../StaminaComponent"
@onready var weapon_manager = $"../WeaponManager"
@onready var reload_state = $"../StateMachineAction/Reload"
@onready var health_component = $"../HealthComponent"

var perks: Array[String] = []

func add_perk(perk_name: String):
	"""
	The perk buys call this function, passing us a string of the perk name and the
	logic to apply that perk's effect to the player happens here. If a perk needs
	to be in a process function, that will happen here as well.
	"""
	assert(perks.find(perk_name) == -1, "Adding perk we already have!")

	perks.append(perk_name)
	Events.emit_signal("player_perks_change", perks)
	apply_perk(perk_name)

func apply_perk(perk_name: String):
	assert(Globals.PERK_INDEX.keys().find(perk_name) != -1, "Perk name doesnt match global index: " + perk_name)

	match perk_name:
		"STAMINA_BOOST":
			stamina_component.max_stamina = stamina_component.starting_max_stamina * 2.0
			stamina_component.stamina_regen_per_tick = stamina_component.starting_regen_per_tick * 1.5
		"RAPID_FIRE":
			weapon_manager.add_modifier("RAPID_FIRE")
		"QUICK_RELOAD":
			reload_state.has_quick_reload = true
		"HEALTH_BOOST":
			health_component.max_health = 60.0
		"STEADY_AIM":
			weapon_manager.add_modifier("STEADY_AIM")
			

