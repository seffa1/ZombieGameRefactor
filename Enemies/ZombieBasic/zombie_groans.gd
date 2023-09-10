extends Node

@onready var short_groans = $"ShortGroans-AudioRandomizer"
@onready var long_groans = $"LongGroans-AudioRandomizer"
@onready var death_groans = $"DeathGroans-AudioRandomizer"
@onready var attack_groans = $"AttackGroans-AudioRandomizer"

func play_short():
	short_groans.play_random()
	
func play_long():
	print(long_groans)
	long_groans.play_random()

func play_attack():
	death_groans.play_random()

func play_death():
	attack_groans.play_random()
