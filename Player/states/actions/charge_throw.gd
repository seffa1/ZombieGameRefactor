extends "res://Libraries/state.gd"

@onready var equipment_manager = $"../../EquipmentManager"
@onready var gun_sprite = $"../../SkeletonControl/HandPosition/GunSprite"
@onready var animation_player = $"../../AnimationPlayer"

# Initialize the state. E.g. change the animation
func enter():
	# Set the gun sprite to the equipment sprite
	gun_sprite.show()  # if we have no gun, we need this
	var equipment_sprite: CompressedTexture2D = Globals.EQUIPMENT_INDEX[equipment_manager.current_equipment].sprite
	gun_sprite.texture = equipment_sprite

	# Player the animation
	animation_player.play("charge_throw")

	return

func update(delta):
	# If we stop holding the equipment button, go to throw state
	if !Input.is_action_pressed("equipment"):
		emit_signal("finished", "throw")
		return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event):
	return

