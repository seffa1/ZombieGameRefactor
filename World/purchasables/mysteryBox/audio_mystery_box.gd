extends AudioStreamPlayer2D

@onready var audio_closed = preload("res://World/purchasables/mysteryBox/audio/GLTCH_SFX_LatchImpact6.wav")
@onready var audio_buy = preload("res://World/purchasables/mysteryBox/audio/CashRegister_S08OF.40.wav")
@onready var audio_gun_switch = preload("res://World/purchasables/mysteryBox/audio/ESM_GT_cinematic_fx_UI_organic_button_press_04.wav")
@onready var audio_gun_selection = preload("res://World/purchasables/mysteryBox/audio/ESM_Game_Coin_Power_Up_5_Retro_Classic_8_Bit_App_Mobile_Phone_Chirp_Synth_Hit_Casino.wav")
@onready var audio_pickup = preload("res://World/purchasables/mysteryBox/audio/ESM_Shotgun_Pump_23_Sound_FX_Military_Cock.wav")

func play_buy():
	stream = audio_buy
	play()

func play_gun_switch():
	stream = audio_gun_switch
	play()

func play_gun_selection():
	stream = audio_gun_selection
	play()
	
func play_gun_pickup():
	stream = audio_pickup
	play()
	
func play_closed():
	stream = audio_closed
	play()
