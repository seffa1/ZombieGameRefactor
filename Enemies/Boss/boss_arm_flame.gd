extends Node2D

@onready var target: Node2D = %Target
@onready var flame_timer: Timer = %FlameTimer
@onready var idle_timer: Timer = %IdleTimer
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var average_animation_interval: float = 8.0
@export var animation_interval_variance: float = .5  # 50%

var animation_names = [
	"idle_1",
	"idle_2",
	"idle_3"
]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if idle_timer.is_stopped():
		idle_timer.start(_choose_interval())
		animation_player.play(_choose_animation())

func _flame_on():
	pass

func _flame_off():
	pass

func _choose_interval() -> float:
	var variance = average_animation_interval * animation_interval_variance
	return randf_range(average_animation_interval - variance, average_animation_interval + variance)

func _choose_animation() -> String:
	return animation_names.pick_random()
