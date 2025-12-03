extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.health_changed.connect(_update_health)

func _update_health(_health : float) -> void:
	print("health changed")
	self.value = float((StatsManager.get_current_health()/StatsManager.get_max_health())*100)
