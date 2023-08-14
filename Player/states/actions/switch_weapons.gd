extends "res://Libraries/state.gd"

@onready var gun_polygon: Polygon2D = $"../../SkeletonControl/polygons/gun"
@onready var weapon_manager = $"../../WeaponManager"

# Initialize the state. E.g. change the animation
func enter():
	owner.animation_player.play("switch_weapons")

func _on_switch_weapon_sprite():
	var new_texture = Globals.GUN_INDEX[weapon_manager.get_equipped_gun_name()].sprite
	gun_polygon.texture = new_texture

func _on_switch_weapon_animation_finished():
	emit_signal("finished", "idle")
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	owner.animation_player.stop()
