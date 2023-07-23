@tool
extends Panel

@onready var value = $Values

func _ready():
	set_as_top_level(true)

func _on_player_player_stamina_change(stamina: int):
	value.text = str(stamina)
