extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.enemy_debug.connect(_on_enemy_debug)

func _on_enemy_debug(visible: bool):
	for label in get_children():
		label.visible = visible
