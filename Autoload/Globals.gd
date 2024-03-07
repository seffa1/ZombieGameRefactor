extends Node

"""
Maps each gun to animation names and other resources it needs.
This is to inform the player states so they can choose the correct animations.
"""

# A reference to the player assigned in GameInitializer
var player = null
var debug_on = true
var debug_enemies = false

# Globally updated variables
var is_power_on: bool = false

# Stores all the information for all guns (should maybe turn this into resources?)
# The key is what we consider the 'weapon name' and is what must match the guns that are created
const GUN_INDEX = {
	"DEV_CANON": {
		"nice_name": "Dev Canon",
		"nice_name_upgraded": "Master Blaster",
		"idle_animation": "idle_riffle",
		"shoot_animation": "shoot_riffle",
		"reload_animation": "reload_riffle",
		"switch_from_animation": "switch_from_riffle",
		"switch_to_animation": "switch_to_riffle",
		"buy_weapon_from_animation": "buy_weapon_from_riffle",
		"buy_weapon_to_animation": "buy_weapon_to_riffle",
		"sprint_animation": "sprint_riffle",
		"sprite": preload("res://World/purchasables/Weapons/AssultRiffles/DevCanon/images/rifle.png"),
		"pickup_sprite": preload("res://World/purchasables/Weapons/AssultRiffles/DevCanon/images/riffle_buy.png"),
		"lower_weapon_animation": "lower_weapon_riffle",
		"scene": preload("res://World/purchasables/Weapons/AssultRiffles/DevCanon/DevCanon.tscn")
	},
	"LSAT": {
		"nice_name": "L-SAT",
		"nice_name_upgraded": "Penatrator",
		"idle_animation": "idle_riffle",
		"shoot_animation": "shoot_riffle",
		"reload_animation": "reload_riffle",
		"switch_from_animation": "switch_from_riffle",
		"switch_to_animation": "switch_to_riffle",
		"buy_weapon_from_animation": "buy_weapon_from_riffle",
		"buy_weapon_to_animation": "buy_weapon_to_riffle",
		"sprint_animation": "sprint_riffle",
		"sprite": preload("res://World/purchasables/Weapons/AssultRiffles/DevCanon/images/rifle.png"),
		"pickup_sprite": preload("res://World/purchasables/Weapons/AssultRiffles/DevCanon/images/riffle_buy.png"),
		"lower_weapon_animation": "lower_weapon_riffle",
		"scene": preload("res://World/purchasables/Weapons/LMGs/WeaponLSAT.tscn")
	},
	"PISTOL_01": {
		"nice_name": "Dev Pistol",
		"nice_name_upgraded": "Stinger",
		"idle_animation": "idle_pistol",
		"shoot_animation": "shoot_pistol",
		"reload_animation": "reload_pistol",
		"switch_from_animation": "switch_from_pistol",
		"switch_to_animation": "switch_to_pistol",
		"buy_weapon_from_animation": "buy_weapon_from_pistol",
		"buy_weapon_to_animation": "buy_weapon_to_pistol",
		"sprint_animation": "sprint_pistol",
		"sprite": preload("res://World/purchasables/Weapons/Pistols/Pistol_01/images/pistol.png"),
		"pickup_sprite": preload("res://World/purchasables/Weapons/Pistols/Pistol_01/sprites/pistol_buy.png"),
		"lower_weapon_animation": "lower_weapon_riffle",
		"scene": preload("res://World/purchasables/Weapons/Pistols/Pistol_01/GunPistol01.tscn")
	},
	"SPAS": {
		"nice_name": "Spas 12",
		"nice_name_upgraded": "Spark Daddy",
		"idle_animation": "idle_riffle",
		"shoot_animation": "shoot_riffle",
		"reload_animation": "reload_riffle",
		"switch_from_animation": "switch_from_riffle",
		"switch_to_animation": "switch_to_riffle",
		"buy_weapon_from_animation": "buy_weapon_from_riffle",
		"buy_weapon_to_animation": "buy_weapon_to_riffle",
		"sprint_animation": "sprint_riffle",
		"sprite": preload("res://World/purchasables/Weapons/Shotguns/Spas/images/shotgun.png"),
		"pickup_sprite": preload("res://World/purchasables/Weapons/shared/images/weapon_pack/weapons_pack_0008_shotgun_1.png"),
		"lower_weapon_animation": "lower_weapon_riffle",
		"scene": preload("res://World/purchasables/Weapons/Shotguns/Spas/Spas.tscn")
	},
	"AUTO_SHOTGUN": {
		"nice_name": "Auto Shotgun",
		"nice_name_upgraded": "Blast Zone",
		"idle_animation": "idle_riffle",
		"shoot_animation": "shoot_riffle",
		"reload_animation": "reload_riffle",
		"switch_from_animation": "switch_from_riffle",
		"switch_to_animation": "switch_to_riffle",
		"buy_weapon_from_animation": "buy_weapon_from_riffle",
		"buy_weapon_to_animation": "buy_weapon_to_riffle",
		"sprint_animation": "sprint_riffle",
		"sprite": preload("res://World/purchasables/Weapons/Shotguns/Spas/images/shotgun.png"),
		"pickup_sprite": preload("res://World/purchasables/Weapons/shared/images/weapon_pack/weapons_pack_0009_shotgun_2.png"),
		"lower_weapon_animation": "lower_weapon_riffle",
		"scene": preload("res://World/purchasables/Weapons/Shotguns/AutoShotgun/AutoShotgun.tscn")
	},
	"50_CAL": {
		"nice_name": ".50 Cal",
		"nice_name_upgraded": "Executioner",
		"idle_animation": "idle_riffle",
		"shoot_animation": "shoot_riffle",
		"reload_animation": "reload_riffle",
		"switch_from_animation": "switch_from_riffle",
		"switch_to_animation": "switch_to_riffle",
		"buy_weapon_from_animation": "buy_weapon_from_riffle",
		"buy_weapon_to_animation": "buy_weapon_to_riffle",
		"sprint_animation": "sprint_riffle",
		"sprite": preload("res://World/purchasables/Weapons/AssultRiffles/DevCanon/images/rifle.png"),
		"pickup_sprite": preload("res://World/purchasables/Weapons/shared/images/weapon_pack/weapons_pack_0015_sniper-rifle_2.png"),
		"lower_weapon_animation": "lower_weapon_riffle",
		"scene": preload("res://World/purchasables/Weapons/Snipers/50Cal/50Cal.tscn")
	},
	"MP7": {
		"nice_name": "MP-7",
		"nice_name_upgraded": "Ripper",
		"idle_animation": "idle_riffle",
		"shoot_animation": "shoot_riffle",
		"reload_animation": "reload_riffle",
		"switch_from_animation": "switch_from_riffle",
		"switch_to_animation": "switch_to_riffle",
		"buy_weapon_from_animation": "buy_weapon_from_riffle",
		"buy_weapon_to_animation": "buy_weapon_to_riffle",
		"sprint_animation": "sprint_riffle",
		"sprite": preload("res://World/purchasables/Weapons/AssultRiffles/DevCanon/images/rifle.png"),
		"pickup_sprite": preload("res://World/purchasables/Weapons/shared/images/weapon_pack/weapons_pack_0007_submachine-gun_2.png"),
		"lower_weapon_animation": "lower_weapon_riffle",
		"scene": preload("res://World/purchasables/Weapons/SubmachineGuns/MP7/MP7.tscn")
	},
	"FULGURIZER": {
		"nice_name": "Fulgurizer",
		"nice_name_upgraded": "Thunder Clap",
		"idle_animation": "idle_riffle",
		"shoot_animation": "shoot_riffle",
		"reload_animation": "reload_riffle",
		"switch_from_animation": "switch_from_riffle",
		"switch_to_animation": "switch_to_riffle",
		"buy_weapon_from_animation": "buy_weapon_from_riffle",
		"buy_weapon_to_animation": "buy_weapon_to_riffle",
		"sprint_animation": "sprint_riffle",
		"sprite": preload("res://World/purchasables/Weapons/Specials/Fulgurizer/images/rifle.png"),
		"pickup_sprite": preload("res://World/purchasables/Weapons/Specials/Fulgurizer/images/riffle_buy.png"),
		"lower_weapon_animation": "lower_weapon_riffle",
		"scene": preload("res://World/purchasables/Weapons/Specials/Fulgurizer/Weapon_Fulgurizer.tscn")
	},
	"FLAMETHROWER": {
		"nice_name": "Flame Thrower",
		"nice_name_upgraded": "Fiery Confluence",
		"idle_animation": "idle_flamethrower",
		"shoot_animation": "shoot_flamethrower",
		"reload_animation": "reload_flamethrower",
		"switch_from_animation": "switch_from_flamethrower",
		"switch_to_animation": "switch_to_flamethrower",
		"buy_weapon_from_animation": "buy_weapon_from_flamethrower",
		"buy_weapon_to_animation": "buy_weapon_to_flamethrower",
		"sprint_animation": "sprint_flamethrower",
		"sprite": preload("res://World/purchasables/Weapons/Specials/Flamethrower/images/riffle&firethrower_0010_Firethrower_man_smaller_2.png"),
		"pickup_sprite": preload("res://World/purchasables/Weapons/Specials/Flamethrower/images/items_0001_fire.png"),
		"lower_weapon_animation": "lower_weapon_flamethrower",
		"scene": preload("res://World/purchasables/Weapons/Specials/Flamethrower/WeaponFlamethrower.tscn")
	},
	"FLAMETHROWER_UPGRADED": {
		"nice_name": "Fiery Confluence",
		"nice_name_upgraded": "Fiery Confluence",
		"idle_animation": "idle_flamethrower",
		"shoot_animation": "shoot_flamethrower",
		"reload_animation": "reload_flamethrower",
		"switch_from_animation": "switch_from_flamethrower",
		"switch_to_animation": "switch_to_flamethrower",
		"buy_weapon_from_animation": "buy_weapon_from_flamethrower",
		"buy_weapon_to_animation": "buy_weapon_to_flamethrower",
		"sprint_animation": "sprint_flamethrower",
		"sprite": preload("res://World/purchasables/Weapons/Specials/Flamethrower/images/riffle&firethrower_0010_Firethrower_man_smaller_2.png"),
		"pickup_sprite": preload("res://World/purchasables/Weapons/Specials/Flamethrower/images/items_0001_fire.png"),
		"lower_weapon_animation": "lower_weapon_flamethrower",
		"scene": preload("res://World/purchasables/Weapons/Specials/Flamethrower/WeaponFlamethrower_Upgraded.tscn")
	},
	"CLUSTER_CANNON": {
		"nice_name": "Cluster Cannon",
		"nice_name_upgraded": "Shatterstorm",
		"idle_animation": "idle_flamethrower",
		"shoot_animation": "shoot_flamethrower",
		"reload_animation": "reload_flamethrower",
		"switch_from_animation": "switch_from_flamethrower",
		"switch_to_animation": "switch_to_flamethrower",
		"buy_weapon_from_animation": "buy_weapon_from_flamethrower",
		"buy_weapon_to_animation": "buy_weapon_to_flamethrower",
		"sprint_animation": "sprint_flamethrower",
		"sprite": preload("res://World/purchasables/Weapons/Specials/Flamethrower/images/riffle&firethrower_0010_Firethrower_man_smaller_2.png"),
		"pickup_sprite": preload("res://World/purchasables/Weapons/Specials/Flamethrower/images/items_0001_fire.png"),
		"lower_weapon_animation": "lower_weapon_flamethrower",
		"scene": preload("res://World/purchasables/Weapons/Specials/ClusterCannon/Weapon_ClusterCannon.tscn")
	},
}

const EQUIPMENT_INDEX = {
	"GRENADE": {
		"nice name": "Grenade",
		"scene": preload("res://World/throwables/ThrowableGrenade.tscn"),
		"sprite": preload("res://World/throwables/images/grenade2-small2.png"),
		"charge_audio": preload("res://World/throwables/sounds/ESM_GW_explosion_one_shot_grenade_remove_safety_bomb_safety_hold_grenade_1.wav"),
		"throw_audio": preload("res://World/throwables/sounds/throw_woosh.wav"),
		"hit_ground_audio": preload("res://World/throwables/sounds/grenade_land.wav")
	},
	"CLUSTER_BOMB": {
		"nice name": "Cluster Bomb",
		"scene": preload("res://World/throwables/ClusterBomb.tscn"),
		"sprite": preload("res://World/throwables/images/grenade2-small2.png"),
		"charge_audio": preload("res://World/throwables/sounds/ESM_GW_explosion_one_shot_grenade_remove_safety_bomb_safety_hold_grenade_1.wav"),
		"throw_audio": preload("res://World/throwables/sounds/throw_woosh.wav"),
		"hit_ground_audio": preload("res://World/throwables/sounds/grenade_land.wav")
	}
}

# Gun name, selection_weight
const mystery_box_spawn_weights = [
		["DEV_CANON", 0.5],
		["PISTOL_01", 0.2],
		["MP7", 0.5],
		["AUTO_SHOTGUN", 0.5],
		["SPAS", 0.5],
		["50_CAL", 0.5],
		["FULGURIZER", 1.0],
		["FLAMETHROWER", 1.0],
		["CLUSTER_CANNON", 1.0],
		["LSAT", 1.0]
	]

# Stores all the information for all perks (should maybe turn this into resources?)
# The key is what we consider the 'perk name' and is what must match the perks that are created
const PERK_INDEX = {
	"STAMINA_BOOST": {
		"nice_name": "Stamina Boost",
		"HUD_image": preload("res://World/purchasables/perks/images/element_0101_Layer-103.png")
	},
	"RAPID_FIRE": {
		"nice_name": "Rapid Fire",
		"HUD_image": preload("res://World/purchasables/perks/images/element_0100_Layer-102.png")
	},
	"HEALTH_BOOST": {
		"nice_name": "Health Boost",
		"HUD_image": preload("res://World/purchasables/perks/images/element_0098_Layer-100.png")
	},
	"QUICK_RELOAD": {
		"nice_name": "Quick Reload",
		"HUD_image": preload("res://World/purchasables/perks/images/element_0099_Layer-101.png")
	},
	"STEADY_AIM": {
		"nice name": "Steady Aim",
		"HUD_image": preload("res://World/purchasables/perks/images/steady_aim_icon.png")
	}
}

# Determines the kind of death animation enemies use
const DAMAGE_TYPES = [
	'bullet',
	'explosive',
	'fire',
	'electric',
	'frost'
]

# Utils
func mouse_on_screen() -> bool:
	if get_viewport().get_mouse_position().x > get_viewport().get_visible_rect().size.x or get_viewport().get_mouse_position().x < 0:
		return false
	if get_viewport().get_mouse_position().y > get_viewport().get_visible_rect().size.y or get_viewport().get_mouse_position().y < 0:
		return false
	return true

var rng = RandomNumberGenerator.new()

func get_random_number(range: int):
	return rng.randi_range(-range, range)
