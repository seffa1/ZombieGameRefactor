extends "res://Libraries/state.gd"

@onready var equipment_manager = $"../../EquipmentManager"
@onready var gun_sprite = $"../../SkeletonControl/HandPosition/GunSprite"
@onready var hand_position = $"../../SkeletonControl/HandPosition"

# Initialize the state. E.g. change the animation
func enter():
	# Spawn in the equipment
	var equipment_object = Globals.EQUIPMENT_INDEX[equipment_manager.current_equipment].scene.instantiate()
	equipment_object.global_position = hand_position.global_position
	equipment_object.rotation = hand_position.rotation
	
	
	# Hide the gun sprite
	gun_sprite.hide()
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event):
	return

func update(delta):
	return
