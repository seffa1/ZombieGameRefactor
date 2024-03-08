extends "res://Libraries/state.gd"

@onready var animation_player = $"../../AnimationPlayer"
@onready var hand_position = $"../../SkeletonControl/HandPosition"
@onready var equipment_manager = $"../../EquipmentManager"
@onready var weapon_manager = $"../../WeaponManager"
@onready var gun_sprite = $"../../SkeletonControl/HandPosition/GunSprite"
@onready var action_sound_player = $"../../ActionSoundPlayer"
@onready var charge_state = $"../ChargeThrow"

var item_ejection_torque: float = 20000  # angular momentum applied to item on ejection
var item_ejection_torque_variance: float = 18000

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
	var charge_value = charge_state.charge_value
	var direction_vector = Vector2.RIGHT.rotated(owner.rotation) *  charge_value * 200
	equipment_object.apply_impulse(direction_vector)
	
	# Give it some random torque
	equipment_object.apply_torque(item_ejection_torque + randf_range(-item_ejection_torque_variance, item_ejection_torque_variance))
	
	# play the equipment throw audio
	var audio = Globals.EQUIPMENT_INDEX[equipment_manager.current_equipment].throw_audio
	action_sound_player.stream = audio
	action_sound_player.play()
	
	# Reduce count
	equipment_manager.equipment_count -= 1
	
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
