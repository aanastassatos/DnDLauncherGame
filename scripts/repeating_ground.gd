extends Node2D

@export var segment_one : Node2D
@export var segment_two : Node2D
@export var segment_three : Node2D
@export var camera : Camera2D

@export var segment_width : float = 1170.0

var segments : Array[Node2D] = []


func _ready() -> void:
	segments = [segment_one, segment_two, segment_three]
	# (Optional) Ensure they are sorted left → right by x
	segments.sort_custom(func(a, b): return a.global_position.x < b.global_position.x)


func _process(_delta: float) -> void:
	if camera == null:
		return

	var cam_center = camera.global_position
	var half_view = (camera.get_viewport_rect().size.x * 0.5) * camera.zoom.x

	var cam_left = cam_center.x - half_view
	var cam_right = cam_center.x + half_view

	for seg in segments:
		var seg_left = seg.global_position.x
		var seg_right = seg_left + segment_width

		# If this segment is fully left of the camera's left edge → move it forward
		if seg_right < cam_left:
			seg.global_position.x += segment_width * segments.size()

		# If camera moves left and the segment is too far to the right → move backward
		if seg_left > cam_right:
			seg.global_position.x -= segment_width * segments.size()
