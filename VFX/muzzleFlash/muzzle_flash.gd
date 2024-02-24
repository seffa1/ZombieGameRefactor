extends PointLight2D

@export var muzzle_flashes: Array[CompressedTexture2D]

@onready var sprite: Sprite2D = %Sprite

func _ready():
	sprite.texture = muzzle_flashes.pick_random()

