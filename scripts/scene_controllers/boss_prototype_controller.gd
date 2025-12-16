extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StatsManager.launch_power_level = 5
	StatsManager.bounce_force_level = 5
	StatsManager.forward_force_level = 5
	StatsManager.health_level = 0
	StatsManager.air_drag_level = 5
	StatsManager.ground_drag_level = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
