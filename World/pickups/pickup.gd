extends Node2D


"""
Base class for all pickups:
	max_ammo, instakill, nuke, carpenter, etc.

Must define the sprite export variables and _trigger_pickup_effect
and this class does the rest.

The animation player controls all the audio, which is shared between all the different
pickups.
"""

@export var sprite_texture: Texture

# Nodes
@onready var audio: AudioStreamPlayer2D = $Audio
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite
@onready var player_detector = $PlayerDetector

func _ready():
	animation_player.play("spawn")
	sprite.texture = sprite_texture

func _on_player_detector_body_entered(player: CharacterBody2D):
	"""
	The player should be the only body that triggers this.
	This will play the pickup animation, pickup sound, then
	call _trigger_pickup_effect(player) which will either:
		modify the player: max_ammo, instakill
		spawn a nuke effect: nuke
		repair all the windows: carpenter
		something else ???
		
	The pickup animation should:
		hide the sprite
		wait long enough to play the pick up audio
		then call queue_free()
	"""

	# TODO - play a second sound over this for the annoucer (audio_pickup_vocal)
	# ex. in cod when you get a max ammo you hear: "MAX AMMO!!" from an announcer
	# I think the announce audio should happen outside this script, probably in 
	# the global events bus. If thats the case we'll define a new export variable
	# in this base class which will be passed to the event bus signal so it can
	# play the correct audio annuncement
	animation_player.play("pickup")
	player_detector.monitoring = false
	_trigger_pickup_effect(player)

func _trigger_pickup_effect(player: CharacterBody2D):
	"""
	Must be defined for all children classes. 
	See _on_player_detector_body_entered for more information
	on what this should do.
	"""
	return

func _on_spawn_animation_complete():
	animation_player.play("idle")
