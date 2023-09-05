extends AudioStreamPlayer2D


@onready var audio_buy = preload("res://World/purchasables/mysteryBox/audio/CashRegister_S08OF.40.wav")
@onready var audio_pickup = preload("res://World/purchasables/mysteryBox/audio/ESM_Shotgun_Pump_23_Sound_FX_Military_Cock.wav")

func play_buy():
	stream = audio_buy
	play()

func play_gun_pickup():
	stream = audio_pickup
	play()
	

