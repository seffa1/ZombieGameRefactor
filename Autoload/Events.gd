extends Node

"""
Autoload single that holds signals that would be hard to wire up normally.
The game initializer instead connects things up to this signal.
"""

# Menus
signal game_paused()
signal game_resumed()
signal game_quit()
signal open_settings()
signal return_to_main_menu()

# HUD
signal player_log(message: String)
signal update_interactable_log(message: String)
signal player_stamina_change(stamina: int)
signal player_direction_change(direction_string: String)
signal player_velocity_change(velocity: Vector2)
signal player_money_change(money: int)
signal player_rotation_change(rotation)
signal player_position_change(position: Vector2) # used by all zombies to track player, and debug UI
signal player_perks_change(perks: Array[String])
signal player_equipped_clip_count_change(count: int)  # bullets in current clip
signal player_equipped_reserve_count_change(count: int)  # bullets remaing
signal player_weapons_change(weapon_names: Array[String])
signal player_equipped_change(weapon_name: String)

signal zombies_to_kill_change(amount: int)
signal wave_number_change(wave: int)
signal zombies_on_map_change(quantity: int)

# Player Interactions
signal give_player_money(amount: int)
signal player_buy_weapon()
signal player_stop_sprinting()
signal player_knockback(direction: Vector2)
signal lower_weapon()
signal raise_weapon()

# Player states (used for the reticle)
signal player_idle()
signal player_moving()
signal player_sprinting()

# FX
signal shake_screen(intensity, duration)

# Game loop
signal wave_started(wave_number)
signal zombie_death(zombie: CharacterBody2D)
