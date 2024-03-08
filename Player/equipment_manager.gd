extends Node

"""
Tracks all equipment.
"""


@export var max_equipment_count: int = 4
func _ready():
	self.equipment_count = max_equipment_count
	Events.give_player_grenade.connect(_handle_give_grenade)

var equipment_count: int:
	set(value):
		var new_count
		if value > max_equipment_count:
			new_count = max_equipment_count
		elif value < 0:
			new_count = 0
		else:
			new_count = value
		equipment_count = new_count
		Events.emit_signal("player_equipment_change", current_equipment, equipment_count)
	get:
		return equipment_count

var current_equipment: String: 
	set(value):
		assert(Globals.EQUIPMENT_INDEX.keys().find(value) != -1, "You are adding an equipment name that isnt in the global EQUIPMENT_INDEX")
		current_equipment = value
		Events.emit_signal("player_equipment_change", current_equipment, equipment_count)
	get:
		return current_equipment

func refill_equipment():
	equipment_count = max_equipment_count



func has_equipment() -> bool:
	return (equipment_count > 0 and current_equipment != '')

func _handle_give_grenade():
	equipment_count += 1
