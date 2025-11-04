extends PlayerState

func _ready():
	if animation_name == "":
		animation_name = "Idle"
	
	if state_name == "":
		state_name = "Aiming"

func enter() -> void:
	super()

func exit() -> void:
	super()

func doProcess(delta: float) -> PlayerState:
	parent.doIdleRotation(delta)
	return null
