extends "res://Libraries/state.gd"

@onready var equipment_manager = $"../../EquipmentManager"
@onready var gun_sprite = $"../../SkeletonControl/HandPosition/GunSprite"
@onready var equipment_container = $"../../SkeletonControl/HandPosition/EquipmentContainer"
@onready var animation_player = $"../../AnimationPlayer"

var equipment_object  # reference to the instantiated equipment

# Initialize the state. E.g. change the animation
func enter():
	# Spawn in the equipment and add it to the hand position so it stays attached to it
	equipment_object = Globals.EQUIPMENT_INDEX[equipment_manager.current_equipment].scene.instantiate()
	equipment_container.add_child(equipment_object)
	
	# Player the animation
	animation_player.play("charge_throw")

	# Hide the gun sprite
	gun_sprite.hide()
	return

func update(delta):
	# If we stop holding the equipment button, go to throw state
	if !Input.is_action_pressed("equipment"):
		emit_signal("finished", "throw")
		return

# Clean up the state. Reinitialize values like a timer
func exit():
	equipment_object = null
	return

func handle_input(event):
	return

