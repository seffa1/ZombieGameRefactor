extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var log_message: Label = $Label

func _ready() -> void:
	Events.update_interactable_log.connect(show_message)
	log_message.text = ""

func show_message(message: String):
	log_message.text = message


