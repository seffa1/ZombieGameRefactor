extends "res://Libraries/state.gd"

@onready var equipment_manager = $"../../EquipmentManager"
@onready var gun_sprite = $"../../SkeletonControl/HandPosition/GunSprite"
@onready var animation_player = $"../../AnimationPlayer"
@onready var action_sound_player = $"../../ActionSoundPlayer"

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

	return

func update(delta):
	# If we stop holding the equipment button, go to throw state
	if !Input.is_action_pressed("equipment"):
		emit_signal("finished", "throw")
		return

# Clean up the state. Reinitialize values like a timer
func exit():
	# If we cancel out of this state
	gun_sprite.hide()
	return

func handle_input(event):
	return

