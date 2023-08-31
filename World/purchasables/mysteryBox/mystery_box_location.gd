extends Node2D

"""
Locations where the mystery box can teleport to. Has an option to be a "starting location".
The box will randomly choose a location which is flagged as a "starting location" to start at.
"""

@export var is_starting_location: bool = false
