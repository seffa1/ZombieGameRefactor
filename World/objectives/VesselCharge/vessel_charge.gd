extends Node2D

@onready var zombie_detector: Area2D = $ZombieDetector
@onready var zombie_soul_scene = preload("res://World/objectives/VesselCharge/ZombieSoul.tscn")
@onready var chargable_light_flicker: Light2D = $ChargableLightFlicker
@export var souls_needed_to_charge: float = 50.0

var max_light_energy: float = 0.7
var energy_per_soul: float
var souls_collected = 0

func _ready():
	Events.zombie_death.connect(_on_zombie_death)
	Events.vessel_charged.connect(_on_vessel_charged)
	energy_per_soul = max_light_energy / souls_needed_to_charge


func _on_zombie_death(zombie: CharacterBody2D):
	if zombie_detector.overlaps_body(zombie):
		spawn_zombie_soul(zombie.global_position)

func _on_vessel_charged(zombie_soul: Node2D):
	souls_collected += 1
	chargable_light_flicker.charge()

	# TODO - add animation
	print("Soul Collected: " + str(souls_collected) + " / " + str(souls_needed_to_charge))
	
	if souls_collected >= souls_needed_to_charge:
		complete_charging()

func spawn_zombie_soul(spawn_location: Vector2):
	var instance = zombie_soul_scene.instantiate()
	instance.global_position = spawn_location
	instance.init(global_position)  # Target location is the vessel's global position
	ObjectRegistry.register_effect(instance)
	
func complete_charging():
	zombie_detector.monitoring = false
	# TODO - add animation
