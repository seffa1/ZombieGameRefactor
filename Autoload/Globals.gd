extends Node

# A reference to the player assigned in GameInitializer
var player = null

# Stores all the information for all guns (should maybe turn this into resources?)
# The key is what we consider the 'weapon name' and is what must match the guns that are created
const GUN_INDEX = {
	"DEV_CANON": {
		"nice_name": "Dev Canon",
		"shoot_animation": "shoot_dev_canon"
	}
}

