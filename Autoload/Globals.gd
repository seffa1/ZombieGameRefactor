extends Node

"""
Maps each gun to animation names and other resources it needs.
This is to inform the player states so they can choose the correct animations.
"""

# A reference to the player assigned in GameInitializer
var player = null
var debug_on = true

# Stores all the information for all guns (should maybe turn this into resources?)
# The key is what we consider the 'weapon name' and is what must match the guns that are created
const GUN_INDEX = {
	"DEV_CANON": {
		"nice_name": "Dev Canon",
		"idle_animation": "idle_riffle",
		"shoot_animation": "shoot_riffle",
		"reload_animation": "reload_riffle",
		"switch_from_animation": "switch_from_riffle",
		"switch_to_animation": "switch_to_riffle",
		"buy_weapon_from_animation": "buy_weapon_from_riffle",
		"buy_weapon_to_animation": "buy_weapon_to_riffle",
		"sprint_animation": "sprint_riffle",
		"sprite": preload("res://World/purchasables/Weapons/DevCanon/images/rifle.png"),
		"lower_weapon_animation": "lower_weapon_riffle"
	},
	"PISTOL_01": {
		"nice_name": "Dev Pistol",
		"idle_animation": "idle_pistol",
		"shoot_animation": "shoot_pistol",
		"reload_animation": "reload_pistol",
		"switch_from_animation": "switch_from_pistol",
		"switch_to_animation": "switch_to_pistol",
		"buy_weapon_from_animation": "buy_weapon_from_pistol",
		"buy_weapon_to_animation": "buy_weapon_to_pistol",
		"sprint_animation": "sprint_pistol",
		"sprite": preload("res://World/purchasables/Weapons/Pistol_01/images/pistol.png"),
		"lower_weapon_animation": "lower_weapon_riffle"
	}
}

# Stores all the information for all perks (should maybe turn this into resources?)
# The key is what we consider the 'perk name' and is what must match the perks that are created
const PERK_INDEX = {
	"STAMINA_BOOST": {
		"nice_name": "Stamina Boost"
	}
}

# Stores all the information for all the different zombie types
const ZOMBIE_INDEX = {
}


# Utils
func mouse_on_screen() -> bool:
	if get_viewport().get_mouse_position().x > get_viewport().get_visible_rect().size.x or get_viewport().get_mouse_position().x < 0:
		return false
	if get_viewport().get_mouse_position().y > get_viewport().get_visible_rect().size.y or get_viewport().get_mouse_position().y < 0:
		return false
	return true
