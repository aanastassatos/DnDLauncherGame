extends PlayerState

func _ready() -> void:
	if animation_name == "":
		animation_name = "Idle"
	
	if state_name == "":
		state_name = parent.LANDED

func enter() -> void:
	super()
	parent.stop_movement()
	EventBus.emit_signal("player_landed")

func doProcess(delta: float) -> PlayerState:
	parent.doIdleRotation(delta)
	return null
