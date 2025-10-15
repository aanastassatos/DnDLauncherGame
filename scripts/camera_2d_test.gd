extends Camera2D

func _process(delta):
	position.x += delta*1000
	print("camera", str(position))
