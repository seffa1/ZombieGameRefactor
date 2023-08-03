extends Node

# A reference to the player assigned in GameInitializer
var player = null

# Stores all the information for all guns (should maybe turn this into resources?)
# The key is what we consider the 'weapon name' and is what must match the guns that are created
const GUN_INDEX = {
	"DEV_CANON": {
		"nice_name": "Dev Canon",
		"shoot_animation": "shoot_dev_canon",
		"reload_animation": "reload_dev_canon"
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
	1: 10,
	2: 10,
	3: 15,
	4: 20,
	5: 30,
	6: 40,
	7: 50,
	8: 1000
}
