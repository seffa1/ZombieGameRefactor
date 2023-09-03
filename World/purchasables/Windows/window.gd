extends "res://World/purchasables/purchasable.gd"

"""
This is using the same system as buying items, hence the "give_item" call.
But we consider it as a buy for 0, and it gives you money, and repairs the window.
"""


@export var window_repair_money_reward: int = 10
@onready var health_component: Node2D = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlaceholder
@onready var window_collision: StaticBody2D = $StaticBody2D
@onready var window_hurt_box: Area2D = $WindowHurtbox


func give_item(_player: CharacterBody2D) -> void:
	"""
	Repair the window.
	"""
	Events.emit_signal("player_log", "Repaired " + purchasable_name)
	Events.emit_signal("give_player_money", window_repair_money_reward)
	
	health_component.health += 1  # Window gets 1 health for each repair
	update_animation_frame(health_component.health)
	return

func get_interactable_message(player: CharacterBody2D) -> String:
	if can_be_purchased:
		return "Repair " + purchasable_name
	else:
		return ""

func update_animation_frame(health: int) -> void:
	"""
	Frame here is really seconds. But The animation should have 1 second
	step size to effectively make 1sec/frame.
	"""
	var MAX_FRAMES_MAX_HEALTH = 7
	var frame = MAX_FRAMES_MAX_HEALTH - health
	animation_player.play("window_break")
	animation_player.seek(float(frame), true)
	animation_player.pause()
	
	# set window collisions and hurtbox at the end of the current frame
	if health_component.health <= 0:
		# Disable the zombie collision layer
		window_collision.set_collision_mask_value(4, false)

	else:
		# Enable the zombie collision layer
		window_collision.set_collision_mask_value(4, true)


func is_broken() -> bool:
	return health_component.health <= 0
