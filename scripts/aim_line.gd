extends Line2D

var aiming: bool = true
var aim_angle: float = -45
var min_angle: float = 0.0
var max_angle: float = 85.0
var power : float = 5000
var swing_speed : float = 90.0
var swinging_down : bool = true
var active : bool = false

func _process(delta):
	if active:
		if swinging_down:
			aim_angle += swing_speed * delta
			if aim_angle >= -min_angle:
				aim_angle = -min_angle
				swinging_down = false
				
		else:
			aim_angle -= swing_speed * delta
			if aim_angle <= -max_angle:
				aim_angle = - max_angle
				swinging_down = true

		rotation = deg_to_rad(aim_angle)
		
func start():
	active = true
	
func stop():
	active = false
