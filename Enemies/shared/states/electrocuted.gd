extends "res://Libraries/state.gd"

"""
If the zombie is outside attacking a window and a player comes within range, the
zombie should reach through the window to hit the player (like in cod).
"""

@onready var conductable_component: Area2D = %ConductableComponent
@onready var health_components: Node = %HealthComponents
@onready var head_health_component: Node2D = %"HealthComponent - Head"

var damage_per_second: float
var electrocution_time: float

var DAMAGE_TYPE = 'electric'

func _ready():
	assert(Globals.DAMAGE_TYPES.find(DAMAGE_TYPE) != -1, 'Undeclared damage type')

# Initialize the state. E.g. change the animation
func enter():
	owner.animation_player.play('electrocuted')
	self.damage_per_second = conductable_component.damage_per_second
	self.electrocution_time = conductable_component.electrocution_time

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func update(delta):
	# movement
	owner.velocity_component.decelerate(delta)
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()

	# Damage
	for health_component in health_components.get_children():
		health_component.health -= (delta * damage_per_second)
		health_component.set_damage_source(DAMAGE_TYPE)

func _on_animation_finished(anim_name):
	return

