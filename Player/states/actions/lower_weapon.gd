extends "res://Libraries/state.gd"

@onready var animation_player = $"../../AnimationPlayer"
@onready var weapon_manager = $"../../WeaponManager"

var isRaisingWeapon = false

func _ready():
	Events.raise_weapon.connect(_on_player_raise_weapon)

# Enter and lower the weapon
func enter():
	isRaisingWeapon = false
	var animation_name = Globals.GUN_INDEX[weapon_manager.get_equipped_gun_name()].lower_weapon_animation
	animation_player.play(animation_name)

# Then pause the animation in the lower state
func _on_player_lower_weapon_animation_finished():
	animation_player.pause()

# If we get the signal from the gun's raycast that we are away from the wall now, then raise the gun and play animation backwards
func _on_player_raise_weapon():
	# Reverse whatever animation played for the lowering, then check the frame in the process function
	isRaisingWeapon = true
	animation_player.play_backwards()

# TODO If raising the gun, check when the animation has been reversed - or else it snaps back to idle and looks ugly
func _process(delta):
	if isRaisingWeapon:
		emit_signal("finished", "idle")
		# reset this so we dont keep emitting this signal infinitely
		isRaisingWeapon = false 

# Clean up the state. Reinitialize values like a timer
func exit():
	animation_player.stop()

func handle_input(_event):
	return

func update(_delta):
	return
