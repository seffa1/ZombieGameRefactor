extends Node2D

@onready var player_hit_box: Area2D = $PlayerHitBox

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("spit_pool")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_hit_box.has_overlapping_areas():
		# Do damage to player, then prevent damage until timer runs out
		if $DamageTimer.is_stopped():
			$DamageTimer.start(3)
			player_hit_box.monitorable = false
			player_hit_box.monitoring = false


func _on_damage_timer_timeout():
	player_hit_box.monitorable = true
	player_hit_box.monitoring = true
