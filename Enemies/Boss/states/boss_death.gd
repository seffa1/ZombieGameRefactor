extends "res://Libraries/state.gd"

@onready var gore_vfx: Node2D = %GoreVFX

func _ready():
	pass

func enter():
	Events.emit_signal("boss_death")
	# func explosion_death(zombie_position: Vector2, explosion_position: Vector2):
	#gore_vfx.explosion_death(owner.global_position, (Globals.player.global_position - owner.global_position))
	gore_vfx.zombie_death()
	gore_vfx.play_splatter()
	Events.emit_signal("shake_screen", 15, .3)

# Clean up the state. Reinitialize values like a timer
func exit():
	pass

func update(delta):
	owner.queue_free()

