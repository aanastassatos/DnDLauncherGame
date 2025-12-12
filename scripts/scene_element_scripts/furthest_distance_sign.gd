class_name FurthestDistanceSign
extends Node2D

@export var ground_y_level : float = 0.0
@export var position_offset : float = 20.0

@onready var distance_label : Label = $RotateableRoot/SignLabelControl/SignMargins/SignLines/DistanceLabel
@onready var sprite : Sprite2D = $RotateableRoot/SignSprite

var size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	distance_label.text = str(0)
	size = sprite.texture.get_size()
	ground_y_level = position.y

func set_futhest_distance(distance : float) -> void:
	position.x = distance+position_offset
	position.y = ground_y_level
	
	distance_label.text = str(roundi(RunManager.get_furthest_distance_in_meters())) +" m"
