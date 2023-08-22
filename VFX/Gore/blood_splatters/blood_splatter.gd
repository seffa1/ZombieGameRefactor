extends "res://VFX/self_freeing_component.gd"

@export var splatter_size = 300

@onready var blood_sprites = [
	preload("res://VFX/Gore/blood_splatters/images/pngwing/pngwing.com (1).png"), 
	preload("res://VFX/Gore/blood_splatters/images/pngwing/pngwing.com (2).png"),
	preload("res://VFX/Gore/blood_splatters/images/pngwing/pngwing.com (3).png"),
]

@onready var sprite = $ScaleController/Sprite

func _ready():
	var index = randi_range(0, len(blood_sprites) - 1)
	sprite.texture = blood_sprites[index]
	
	var width = sprite.get_rect().size.x
	# width * x = 300
	# x = 300 / width
	var scale_factor = splatter_size / width
	sprite.scale.x = scale_factor
	sprite.scale.y = scale_factor
	
	
	super._ready()
