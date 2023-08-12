extends CanvasLayer


@onready var states_stack_displayer_1 = $StatesStackDiplayer
@onready var states_stack_displayer_2 = $StatesStackDiplayer2
@onready var player_stats = $PlayerStats
@onready var pause_menu = $PauseMenu
@onready var settings_menu = $SettingsMenu

func _ready():
	Events.game_resumed.connect(_on_game_resumed) # emited by pause menu
	Events.game_quit.connect(_on_game_quit) # emited by pause menu
	Events.game_paused.connect(_on_game_paused)

func _on_game_resumed():
	print("Game Resumed")
	pause_menu.hide()
	settings_menu.hide()
	get_tree().paused = false

func _on_game_quit():
	get_tree().quit()

func _unhandled_input(event):
	if get_tree().paused:
		return

	if event.is_action_pressed("pause"):
		Events.emit_signal("game_paused")
	
	if event.is_action_pressed("toggle_debug"):
		states_stack_displayer_1.visible = !states_stack_displayer_1.visible
		states_stack_displayer_2.visible = !states_stack_displayer_2.visible
		player_stats.visible = !player_stats.visible

func _on_game_paused():
	print("Game pausing from UI")
	pause_menu.open()
