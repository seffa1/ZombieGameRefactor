extends "res://World/purchasables/purchasable.gd"

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var lockdown_timer: Timer = %LockdownTimer
@onready var light_flicker = $LightFlicker
@onready var overload_audio = %OverloadAudio
@onready var alarm: Light2D = %Alarm

@export var vessel_count: int = 3
@export var lockdown_duration: int = 60
@export var overload_spawners: Array[Node2D]

var vessel_overload_count: int = 0

signal overload_started
signal overload_ended

func _ready():
	Events.vessel_overload_complete.connect(_on_vessel_overload)
	can_be_purchased = true

func _on_vessel_overload():
	vessel_overload_count += 1

func purchase_item(player: CharacterBody2D) -> void:	
	if !can_be_purchased:
		return

	if vessel_overload_count < vessel_count:
		Events.emit_signal("player_log", "Requires 3 overload sequences to open. Only " + str(vessel_overload_count) + " complete.")
		return
	give_item(player)
	
func give_item(player: CharacterBody2D) -> void:
	"""
	Function which must be defined by all children classes.
	"""
	Events.emit_signal("player_log", "Override sequence activated.")
	animation_player.play("keycard_insert")
	can_be_purchased = false
	emit_signal("overload_started")
	lockdown_timer.start(lockdown_duration)
	alarm.start()
	for audio in overload_audio.get_children():
		audio.play()

func _on_lockdown_timer_timeout():
	animation_player.play("open")
	alarm.stop()
	for audio in overload_audio.get_children():
		audio.stop()

func get_interactable_message(player: CharacterBody2D) -> String:
	if vessel_overload_count < vessel_count:
		return "Requires 3 overload sequences to open. Only " + str(vessel_overload_count) + " complete."
	else:
		return "Override vault controls."



