extends Control

"""
Short, temporary messages in the HUD to give information to the player like:
	'dont have enough money!', 'door opened', etc.
Called by a signal in the Events autoload singleton.
"""

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var log_message: Label = $Control/LogMessage

func _ready() -> void:
	Events.player_log.connect(show_message)

func show_message(message: String):
	log_message.text = message
	animation_player.play("show_message")
