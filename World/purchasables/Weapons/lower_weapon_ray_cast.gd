extends RayCast2D

# holds the state of the cast and checks when it changes
var isWeaponLowered = false:
	set(value):
		# If we either hit or backed away from the wall
		
		if value != isWeaponLowered:
			# If we need to lower weapn
			if value:
				Events.emit_signal("lower_weapon")
			# Raise weapon
			else:
				Events.emit_signal("raise_weapon")
			isWeaponLowered = value

func _process(delta):
	self.isWeaponLowered = is_colliding()
