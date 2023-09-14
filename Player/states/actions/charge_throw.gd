extends "res://Libraries/state.gd"

@onready var equipment_manager = $"../../EquipmentManager"
@onready var gun_sprite = $"../../SkeletonControl/HandPosition/GunSprite"
@onready var animation_player = $"../../AnimationPlayer"
@onready var action_sound_player = $"../../ActionSoundPlayer"
@onready var charge_indicator = $"../../ChargeIndicator"

var max_charge_value: float = 3.0
var charge_value: float  # tracks how long we charged the grenade for

# Initialize the state. E.g. change the animation
func enter():
	# Set the gun sprite to the equipment sprite
	gun_sprite.show()  # if we have no gun, we need this
	var equipment_sprite: CompressedTexture2D = Globals.EQUIPMENT_INDEX[equipment_manager.current_equipment].sprite
	gun_sprite.texture = equipment_sprite

	# Player the animation
	animation_player.play("charge_throw")
	
	# play the equipment charge audio
	var audio = Globals.EQUIPMENT_INDEX[equipment_manager.current_equipment].charge_audio
	action_sound_player.stream = audio
	action_sound_player.play()
	
	# Initialize charge indicator and value
	charge_value = 0.0
	charge_indicator.show()
	charge_indicator.play()


func update(delta):
	# If we stop holding the equipment button, go to throw state
	if !Input.is_action_pressed("equipment"):
		emit_signal("finished", "throw")
		return

	charge_value = clampf(charge_value + delta * 2.0, 0, max_charge_value)

# Clean up the state. Reinitialize values like a timer
func exit():
	# If we cancel out of this state
	gun_sprite.hide()
	charge_indicator.hide()
	return

func handle_input(event):
	return

