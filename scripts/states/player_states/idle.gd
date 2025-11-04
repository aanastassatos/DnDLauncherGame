extends PlayerState

func _ready() -> void:
	if animation_name == "":
		animation_name = "Idle"
	
	if state_name == "":
		state_name = parent.IDLE

func enter() -> void:
	super()

func exit() -> void:
	pass

func doProcess(delta: float) -> PlayerState:
	return null
