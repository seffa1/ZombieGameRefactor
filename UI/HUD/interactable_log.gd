extends Control

@onready var log_message: Label = $Label

func _ready() -> void:
	Events.update_interactable_log.connect(show_message)
	log_message.text = ""

func show_message(message: String):
	log_message.text = message


