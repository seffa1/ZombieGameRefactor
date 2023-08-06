extends Control

"""
The main
"""

@onready var menu_sounds = $MenuSoundPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED # This is how a pause menu works, see docs
	visible = true
	set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
