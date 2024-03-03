extends RayCast2D

@onready var particles: GPUParticles2D = %FlamethrowerParticles
@onready var fire_hitbox_collision: CollisionShape2D = %CollisionShape2D

func shoot():
	print('fire shooting!')
	particles.emitting = true
	fire_hitbox_collision.disabled = false
	
func stop():
	print('fire stopping!')
	particles.emitting = false
	fire_hitbox_collision.disabled = true
