extends Control

@onready var menu_sounds = $"../../MenuSoundPlayer"
@onready var info_sprite: TextureRect = $DescriptionBox/VBoxContainer/TextureRect
@onready var info_description: Label = $DescriptionBox/VBoxContainer/description

@onready var labs_image = preload("res://VFX/Gore/blood_splatters/images/awezbloodrip/Blood58.png")
@onready var firing_range_image = preload("res://World/purchasables/Weapons/Pistol_01/sprites/pistol_buy.png")

# Control the level description ----------------------------------
func show_firing_range_info():
	info_sprite.texture = firing_range_image
	info_description.text = "The firing range is a place to try out all the different weapons."

func show_labs_info():
	info_sprite.texture = labs_image
	info_description.text = "You woke up and can't remember how you got here. But you must find a way out..."

# Button press handlers ----------------------------------
func _on_firing_range_pressed():
	menu_sounds.play_open()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().change_scene_to_file("res://Main/DevTestChamber.tscn")
	
func _on_labs_pressed():
	menu_sounds.play_open()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().change_scene_to_file("res://Main/TheLabs.tscn")

# Button hover sounds -----------------------------
func _on_firing_range_mouse_entered():
	show_firing_range_info()
	menu_sounds.play_hover()

func _on_labs_mouse_entered():
	show_labs_info()
	menu_sounds.play_hover()



