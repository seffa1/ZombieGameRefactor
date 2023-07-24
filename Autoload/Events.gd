extends Node

"""
Autoload single that holds signals that would be hard to wire up normally.
The game initializer instead connects things up to this signal.
"""


signal player_log(message: String)
signal update_interactable_log(message: String)

signal damaged(target, damage, shooter)
