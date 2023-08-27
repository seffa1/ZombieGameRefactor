extends CharacterBody2D

"""
Holds references to the children nodes which need to be accessed by other children nodes.
Connects to any event bus signals which need to be passed down to child nodes.
"""

# Nodes
@onready var camera_transform = $CameraTransform
@onready var weapon_manager = $WeaponManager
@onready var animation_player = $AnimationPlayer
@onready var perk_manager = $PerkManager
@onready var state_machine_movement = $StateMachineMovement
@onready var state_machine_action = $StateMachineAction
@onready var hit_timer: Timer = $HitTimer
@onready var gun_sprite = $SkeletonControl/GunSprite
@onready var velocity_component = $VelocityComponent

# Constants
@export var money_component: Node
@export var starting_gun: String = "PISTOL_01"
@export var starting_money: int = 0

# TODO - move all stamina logic to a stamina component
var max_stamina: int = 100:
	set(value):
		max_stamina = value

@onready var stamina: int = 0:
	set(value):
		var new_stamina
		if value > max_stamina:
			new_stamina = max_stamina
		elif value < 0:
			new_stamina = 0
		else:
			new_stamina = value
		stamina = new_stamina
		Events.emit_signal("player_stamina_change", new_stamina)

func assign_camera(camera: Camera2D) -> void:
	""" Called by the game initializer. """
	camera_transform.remote_path = camera.get_path()

func _physics_process(_delta):
	Events.emit_signal("player_rotation_change", self.rotation)
	Events.emit_signal("player_position_change", self.position)
	Events.emit_signal("player_velocity_change", self.velocity)

func _ready():
	# Call the settings to trigger change signals to update the HUD
	stamina = max_stamina
	
	# Connect to player interaction signals
	Events.give_player_money.connect(_on_player_give_money)
	Events.player_knockback.connect(_on_player_knockback)
	
	# start the player with a pistol
	weapon_manager.add_weapon(starting_gun)
	money_component.money = starting_money

# Signal consumers
func _on_player_give_money(amount: int):
	money_component.add_money(amount)

func _on_player_knockback(direction: Vector2):
	# dont apply bullet knockback if we arent moving
	if velocity.length() < 100:
		return
	
	# Dont apply bullet knock if its in the same direction as we are moving (so we cant speed ourselves up by shooting)
	if velocity.dot(direction) >= 0:
		return
	
	velocity_component.impulse_in_direction(direction)
	velocity = velocity_component.velocity
