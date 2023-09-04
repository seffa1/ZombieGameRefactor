extends Node2D

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
			owner.max_stamina = 200
		"DOUBLE_TAP":
			pass
		"QUICK_RELOAD":
			pass
		"HEALTH_BOOST":
			pass
		"STEADY_AIM":
			pass
			

