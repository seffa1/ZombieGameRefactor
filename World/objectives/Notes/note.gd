extends "res://World/purchasables/purchasable.gd"

var note_opened: bool = false

func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	if note_opened:
		close_note()
	else:
		note_opened = true
		$"../OpenSound".play()
		player.money_component.money -= purchasable_cost
		Events.emit_signal('show_note')


func _on_area_exited(area):
	close_note()

func close_note():
	note_opened = false
	Events.emit_signal('hide_note')
	$"../CloseSound".play()
	
func get_interactable_message(player: CharacterBody2D) -> String:
	return "Read Note"
