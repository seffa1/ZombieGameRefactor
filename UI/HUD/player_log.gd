extends Control

"""
Short, temporary messages in the HUD to give information to the player like:
	'dont have enough money!', 'door opened', etc.

All purchasables will connect to this.
"""

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var log_message: Label = $LogMessage

func show_message(message: String):
	log_message.text = message
	animation_player.play("show_message")
