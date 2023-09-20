extends "res://Libraries/state.gd"

@onready var animation_player = $"../../AnimationPlayer"

@onready var fall_apart_scene = preload("res://Enemies/ZombieBasic/ZombieFallApart.tscn")

var is_targeting_player = false

func _ready():
	# Connect to player position signal and feed that to the pathfinding component
	Events.player_position_change.connect(_on_player_position_changed)

func enter():
	is_targeting_player = true
	if randi_range(0, 1) == 1:
		animation_player.play("zombie_headless_death")
	else:
		animation_player.play("zombie_headless_death_2")

func _on_player_position_changed(player_position: Vector2):
	# We only consume this signal to update the pathfinding IF we are in this state
	if is_targeting_player:
		owner.pathfinding_component.update_target_position(player_position)

# Clean up the state. Reinitialize values like a timer
func exit():
	is_targeting_player = false
	return

func update(delta):
	# Move - velocity should be getting updated by the pathfinding component
	owner.velocity = owner.velocity_component.velocity
	owner.move_and_slide()
	
	# Rotate
	owner.update_rotation()

func _on_headless_death_animation_finished():
	# TODO - Body should fall apart on death
	var scene = fall_apart_scene.instantiate()
	scene.global_position = owner.global_position
	scene.global_rotation = owner.velocity_component.velocity.angle()
	ObjectRegistry.register_effect(scene)
	
	Events.emit_signal("zombie_death", owner)
	owner.queue_free()


func _on_animation_finished(anim_name):
	return
