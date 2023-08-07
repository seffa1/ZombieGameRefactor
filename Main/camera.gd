extends Camera2D

# min 0, max 1.0, feels good at 0.2-.5
# At zero, the camera follow the player. 
# At 1, the camera will sfollow the mouse ( like an RTS game )
# Any number in-between means the camera floats between
# the player and the mouse.
@export var camera_mouse_offset_ratio: float = 1

var player_position: Vector2

func _ready():
	Events.connect("player_position_change", _update_player_position)

func _update_player_position(position: Vector2):
	player_position = position

func _process(delta):
	"""
	Update camera position via code instead of with a camera transform.
	"""
	var screen_width = get_viewport().get_visible_rect().size.x
	var screen_height =  get_viewport().get_visible_rect().size.y
	# only move the camera if the mouse is in the viewport
	if get_viewport().get_mouse_position().x > get_viewport().get_visible_rect().size.x or get_viewport().get_mouse_position().x < 0:
		return
	if get_viewport().get_mouse_position().y > get_viewport().get_visible_rect().size.y or get_viewport().get_mouse_position().y < 0:
		return
	
	global_position.x = player_position.x + ( (get_global_mouse_position().x - player_position.x ) * camera_mouse_offset_ratio)
	global_position.y = player_position.y + ( (get_global_mouse_position().y - player_position.y ) * camera_mouse_offset_ratio)


