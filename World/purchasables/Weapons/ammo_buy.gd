extends "res://World/purchasables/purchasable.gd"

"""
Base class for all weapon ammo buys. To create a new ammo buy, inherit from this scene,
and change the weapon name (must match that of the globals.gun_index) and update the
cost, and purchasable name for the interactable message.
"""

@export var weapon_name: String
@onready var audio: AudioStreamPlayer2D = $Audio

func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	assert(Globals.GUN_INDEX.keys().find(weapon_name) != -1, "Weapon name doesnt match global index")
	
	# Check if player DOESNT have this gun
	if player.weapon_manager.weapon_names.find(weapon_name) == -1:
		Events.emit_signal("player_log", "Dont have " + weapon_name)
		return
	else:
		# If do, make sure the ammo isnt full
		var weapon_object = player.weapon_manager.get_gun(weapon_name)
		if weapon_object.is_ammo_full():
			Events.emit_signal("player_log", "Ammo full for " + weapon_name)
			return
		
		#make the transaction and pass the gun name along
		audio.play()
		player.money_component.money -= purchasable_cost
		
		player.weapon_manager.refill_weapon_ammo(weapon_object)
		Events.emit_signal("player_log", "Purchased " + purchasable_name)

func _update_can_be_purchased(body: CharacterBody2D) -> void:
	"""
	When the player enters or exits the buy zone, we need to check 
	if they already have this weapon, if so, make it purchasable.
	Called by the area2D signals below.
	"""
	if body.weapon_manager.has_gun(weapon_name):
		can_be_purchased = true
	else:
		can_be_purchased = false

func _on_body_entered(body: CharacterBody2D):
	_update_can_be_purchased(body)


func _on_body_exited(body):
	_update_can_be_purchased(body)
