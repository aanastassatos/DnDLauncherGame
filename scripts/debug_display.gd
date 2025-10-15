extends CanvasLayer

@onready var linear_velocity_label = $Control/linear_velocity

func update_linear_velocity(linear_velocity_vector : Vector2):
	linear_velocity_label.text = str(linear_velocity_vector)
