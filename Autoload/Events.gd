extends Node

"""
Autoload single that holds signals that would be hard to wire up normally.
The game initializer instead connects things up to this signal.
"""

# UI
signal player_log(message: String)
signal update_interactable_log(message: String)

signal player_stamina_change(stamina: int)
signal player_direction_change(direction_string: String)
signal player_money_change(money: int)
signal player_rotation_change(rotation)
signal player_position_change(position) # used by all zombies to track player, and debug UI
signal player_perks_change(perks: Array[String])

signal player_equipped_clip_count_change(count: int)  # bullets in current clip
signal player_equipped_reserve_count_change(count: int)  # bullets remaing

signal player_weapons_change(weapon_names: Array[String])
signal player_equipped_change(weapon_name: String)

# Player Interactions
signal give_player_money(amount: int)

# FX
signal shake_screen(intensity, duration)
