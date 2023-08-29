extends "res://World/purchasables/purchasable.gd"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $StaticBody2D/CollisionShape2D

signal door_opened()

func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	player.money_component.money -= purchasable_cost
	Events.emit_signal("player_log", "Purchased " + purchasable_name)
	
	collision.disabled = true
	animation_player.play("open")
	can_be_purchased = false
	
	# Consumed by zombie spawners to becomem active
	emit_signal("door_opened")
	
	return
