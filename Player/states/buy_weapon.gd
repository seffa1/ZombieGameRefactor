extends "res://Libraries/state.gd"

@onready var gun_sprite = $"../../SkeletonControl/GunSprite"
@onready var animation_player = $"../../AnimationPlayer"

# Both are set by the weapon manager when a player gets a new gun
var switch_from_gun_name: String
var switch_to_gun_name: String

func _on_buy_from_animation_finished():
	# Update the gun sprite
	gun_sprite.texture = Globals.GUN_INDEX[switch_to_gun_name].sprite
	
	var animation_name = Globals.GUN_INDEX[switch_to_gun_name].buy_weapon_to_animation
	animation_player.play(animation_name)

func _on_buy_to_animation_finished():
	emit_signal("finished", "idle")
	return

# Initialize the state. E.g. change the animation
func enter():
	var animation_name = Globals.GUN_INDEX[switch_from_gun_name].buy_weapon_from_animation
	animation_player.play(animation_name)

# Clean up the state. Reinitialize values like a timer
func exit():
	animation_player.stop()

func update(_delta):
	return
func handle_input(_event):
	return
