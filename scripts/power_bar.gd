extends Node2D

# The Line2D node that visually represents the power
@onready var line: Line2D = $PowerLine

# Power bar settings
@export var min_length: float = 10.0
@export var max_length: float = 200.0
@export var speed: float = 300.0  # pixels per second

# Animation state
var growing: bool = true
var active: bool = false
var current_length: float = 10.0

# Normalized power value (0..1)
var power_ratio: float = 0.0

func _ready():
	# Initialize line to start at base point
	line.points[0] = Vector2.ZERO
	line.points[1] = Vector2(current_length, 0)

func _process(delta):
	if not active:
		return

	# Animate bar length
	current_length += (speed * delta) * (1 if growing else -1)

	if current_length >= max_length:
		current_length = max_length
		growing = false
	elif current_length <= min_length:
		current_length = min_length
		growing = true

	# Update line endpoint along local X-axis
	line.points[1] = Vector2(current_length, 0)

	# Update normalized power ratio
	power_ratio = (current_length - min_length) / (max_length - min_length)

func start():
	# Begin the power bar animation
	active = true
	current_length = min_length
	growing = true
	power_ratio = 0.0
	line.points[1] = Vector2(current_length, 0)

func stop() -> float:
	# Stop the animation and return the power ratio
	active = false
	return power_ratio

func set_aim_angle(deg_angle: float):
	# Rotate the whole bar to match aim
	rotation = deg_to_rad(deg_angle)
