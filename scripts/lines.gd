extends Node2D

@export var line_spacing: int = 720 # pixels between lines
@export var line_height: int = 300
@export var line_color: Color = Color.CHARTREUSE
@export var player: NodePath
@export var camera_width: int = 2000

var last_x: float = 0.0
var generated_until: float = 0.0

const PIXELS_PER_METER: float = 72.0

func _process(delta):
	if not player:
		return
		
	var player_node = get_node(player)
	var cam_x = player_node.global_position.x

	# Only generate new lines if the player has moved far enough
	while generated_until < cam_x + camera_width:
		add_distance_marker(generated_until)
		generated_until += line_spacing

func add_distance_marker(x_pos: float):
	
	var meters = x_pos / PIXELS_PER_METER
	
	var line = Line2D.new()
	line.width = 2
	line.default_color = line_color
	line.points = [Vector2(x_pos, -line_height / 2), Vector2(x_pos, line_height / 2)]
	line.z_index = -1
	add_child(line)
	
	if fmod(meters, 10) == 0.0:
		var label = Label.new()
		label.text = str(int(meters)) + " m"
		label.position = Vector2(x_pos + 4, -line_height / 2)
		label.z_index = -1
		add_child(label)
