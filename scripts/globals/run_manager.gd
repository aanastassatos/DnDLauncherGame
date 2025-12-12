extends Node

var current_distance : float
var furthest_distance : float

func _ready() -> void:
	current_distance = 0.0
	furthest_distance = 0.0

func update_distance(distance : float) -> void:
	current_distance = distance
	if current_distance > furthest_distance:
		furthest_distance = current_distance

func get_current_distance_in_meters() -> float:
	return current_distance/Constants.PIXELS_PER_METER

func get_current_distance_in_pixels() -> float:
	return current_distance

func get_furthest_distance_in_meters() -> float:
	return furthest_distance/Constants.PIXELS_PER_METER

func get_furthest_distance_in_pixels() -> float:
	return furthest_distance
