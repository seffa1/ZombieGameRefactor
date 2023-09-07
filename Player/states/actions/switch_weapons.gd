extends "res://Libraries/state.gd"

@onready var gun_polygon: Polygon2D = $"../../SkeletonControl/polygons/gun"
@onready var weapon_manager = $"../../WeaponManager"
@onready var gun_sprite = $"../../SkeletonControl/HandPosition/GunSprite"
@onready var right_hand = $"../../SkeletonControl/Skeleton/torso/shoulderRight/armRight/handRight"

# Initialize the state. E.g. change the animation
func enter():
	owner.animation_player.play(Globals.GUN_INDEX[weapon_manager.get_equipped_gun_name()].switch_from_animation)

func _on_switch_from_animation_finished():
	# switch guns
	weapon_manager.next_weapon()
	# switch textures
	var new_texture = Globals.GUN_INDEX[weapon_manager.get_equipped_gun_name()].sprite
	gun_sprite.texture = new_texture
	# play animation
	owner.animation_player.play(Globals.GUN_INDEX[weapon_manager.get_equipped_gun_name()].switch_to_animation)

func _on_switch_weapon_animation_finished():
	emit_signal("finished", "idle")
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	owner.animation_player.stop()

func update(_delta):
	return
func handle_input(_event):
	return
