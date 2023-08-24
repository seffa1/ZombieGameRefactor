extends "res://Libraries/state.gd"

"""
The sprint action state (this one) cancels all other actions and plays an animation, while
the sprint movement state just handles player movement and leg animations/sounds.
"""

@onready var animation_player = $"../../AnimationPlayer"
@onready var weapon_manager = $"../../WeaponManager"

func _ready():
	# Let the movement sprint state control the action state animation
	Events.player_stop_sprinting.connect(_on_player_stop_sprinting) # emitted from sprint movement state

# Initialize the state. E.g. change the animation
func enter():
	var animation_name = Globals.GUN_INDEX[weapon_manager.get_equipped_gun_name()].sprint_animation
	animation_player.play(animation_name)
	

# Clean up the state. Reinitialize values like a timer
func exit():
	animation_player.stop()

func _on_player_stop_sprinting():
	emit_signal("finished", "idle")
	return

func handle_input(event):
	# if we arent holding sprint down, stop
	if event.is_action_released("sprint"):
		emit_signal("finished", "idle")
		return

func update(_delta):
	return

