extends Node

# A reference to the player assigned in GameInitializer
var player = null
var debug_on = true

# Stores all the information for all guns (should maybe turn this into resources?)
# The key is what we consider the 'weapon name' and is what must match the guns that are created
const GUN_INDEX = {
	"DEV_CANON": {
		"nice_name": "Dev Canon",
		"shoot_animation": "shoot_pistol",
		"reload_animation": "reload_pistol"
	},
	"PISTOL_01": {
		"nice_name": "Pistol 01",
		"shoot_animation": "shoot_pistol",
		"reload_animation": "reload_pistol"
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

# How many enemies per wave
# TODO - replace with a curve or equation
const WAVE_INDEX = {
	1: 0,
	2: 10,
	3: 15,
	4: 20,
	5: 30,
	6: 40,
	7: 50,
	8: 1000
}

# Utils
func mouse_on_screen() -> bool:
	if get_viewport().get_mouse_position().x > get_viewport().get_visible_rect().size.x or get_viewport().get_mouse_position().x < 0:
		return false
	if get_viewport().get_mouse_position().y > get_viewport().get_visible_rect().size.y or get_viewport().get_mouse_position().y < 0:
		return false
	return true
