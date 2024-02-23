extends Node2D


"""
Takes a veritey of status' and applys the effect.
"""
@export_group('Nodes to link')
@export var velocity_component: Node
## hurtboxes receving freeze effect
@export var hurtboxes: Array[Area2D]
@export var freeze_sound: AudioStream

@export_group('Configuration')
@export var freeze_per_hit: float = 10.0
@export var freeze_until_frozen: float = 100.0
@export var velocity_drop_per_point: float = 20.0
## Which node's canvas items is adjusted when frozen
@export var modulator: Node2D
## Which color are we modulating it to
@export_color_no_alpha var freeze_color: Color
@export var frozen_time: float = 5.0
@export var max_freeze: float = 200.0

## Points of freeze removed per second
@export_range(0.0, 50.0, 0.1) var freeze_recovery_rate: float = 10.0

@onready var frozen_timer: Timer = %FrozenTimer
@onready var freeze_audio: AudioStreamPlayer2D = %FreezeAudio

signal frozen(is_frozen: bool)

var freeze_amount: float = 0.0:
	get:
		return freeze_amount
	set(amount):
		if amount <= 0:
			freeze_amount = 0
		elif amount >= max_freeze:
			freeze_amount = max_freeze
		else:
			freeze_amount = amount

var is_frozen: bool = false

func _ready():
	assert(hurtboxes, 'You didnt link hurtboxes for freezable')
	assert(velocity_component, 'You didnt link velocity component to freezeable')
	assert(max_freeze > freeze_until_frozen, 'Frozen Component Setup incorrectly')

	for hurtbox in hurtboxes:
		hurtbox.hurt_box_hit.connect(_on_hurtbox_hit)
	
	freeze_audio.stream = freeze_sound

func _on_hurtbox_hit(body_part: String, area: Area2D):
	if !area.elemental_type == "frost":
		return

	if is_frozen:
		return

	velocity_component.reduce_max(velocity_drop_per_point)
	self.freeze_amount += freeze_per_hit
	
	if freeze_amount >= freeze_until_frozen:
		_freeze()

func _freeze():
	velocity_component.stop()
	is_frozen = true
	# TODO - visual effect / sound effect
	freeze_audio.play()
	# make the zombie tinted blue
	modulator.modulate = freeze_color
	frozen_timer.start(frozen_time)
	emit_signal("frozen", true)
	
func _process(delta):
	self.freeze_amount -= freeze_recovery_rate * delta

func _on_frozen_timer_timeout():
	velocity_component.start()
	is_frozen = false
	emit_signal("frozen", false)

