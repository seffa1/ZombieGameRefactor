extends Camera2D

# min 0, max 1.0, feels good at 0.5
# when zero, the camera stays put, controlled by the player
# transform. At 1, the camera will stay on the mouse.
# Any number in-between means the camera floats between
# the player and the mouse.
@export var camera_mouse_offset_ratio: float = .2
#@export var camera_max_distance: int = 300

var player_position: Vector2

func _ready():
	Events.connect("player_position_change", _update_player_position)

func _update_player_position(position: Vector2):
	player_position = position

func _process(delta):
	print(get_local_mouse_position())
	print(get_global_mouse_position())
	var vector_to_mouse = get_local_mouse_position() - player_position
	global_position = player_position + (vector_to_mouse * camera_mouse_offset_ratio)


