extends CanvasLayer


@onready var states_stack_displayer_1 = $StatesStackDiplayer
@onready var states_stack_displayer_2 = $StatesStackDiplayer2
@onready var player_stats = $PlayerStats
@onready var settings_menu = $SettingsMenu
@onready var menu_sounds = $MenuSoundPlayer
@onready var vinette = $"../GameWorld/Darkness/vinette"


func _ready():
	Events.game_resumed.connect(_on_game_resumed) # emited by pause menu
	Events.game_quit.connect(_on_game_quit) # emited by pause menu
#	Events.game_paused.connect(_on_game_paused)
	Events.return_to_main_menu.connect(_on_return_to_main_menu)


func _on_return_to_main_menu():
	ObjectRegistry.clear_registry()
	get_tree().paused = false
	get_tree().change_scene_to_packed(load("res://UI/MainMenu.tscn"))

func _on_game_resumed():
	settings_menu.hide()
	get_tree().paused = false
	menu_sounds.play_open()
	vinette.show()
	

func _on_game_quit():
	get_tree().quit()

func _unhandled_input(event):
	if get_tree().paused:
		return

	if event.is_action_pressed("pause"):
		settings_menu.open()
		vinette.hide()
	
	if event.is_action_pressed("toggle_debug"):
		states_stack_displayer_1.visible = !states_stack_displayer_1.visible
		states_stack_displayer_2.visible = !states_stack_displayer_2.visible
		player_stats.visible = !player_stats.visible

#func _on_game_paused():
#	Events.emit_signal("open_settings")
