extends "res://Libraries/state.gd"

@onready var animation_player = $"../../AnimationPlayer"
@onready var hand_position = $"../../SkeletonControl/HandPosition"
@onready var equipment_manager = $"../../EquipmentManager"
@onready var weapon_manager = $"../../WeaponManager"
@onready var gun_sprite = $"../../SkeletonControl/HandPosition/GunSprite"

# Initialize the state. E.g. change the animation
func enter():
	animation_player.play("throw")

func _throw_equipment():
	# Create a new instance and attach to the global registry
	var equipment_object = Globals.EQUIPMENT_INDEX[equipment_manager.current_equipment].scene.instantiate()
	equipment_object.global_position = hand_position.global_position
	equipment_object.rotation = hand_position.rotation
	ObjectRegistry.register_equipment(equipment_object)
	
	# Apply the impulse
	# TODO - variable hangtime base on charge up time
	var charge_time = 3.0
	var direction_vector = Vector2.RIGHT.rotated(owner.rotation) *  charge_time * 100
	equipment_object.apply_impulse(direction_vector)
	
func _on_throw_animation_complete():
	emit_signal("finished", "idle")
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(_event):
	return

func update(_delta):
	return
