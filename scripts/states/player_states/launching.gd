extends PlayerState

@export
var launched_state : PlayerState

func _ready():
	if animation_name == "":
		animation_name = "Idle"
	
	if state_name == "":
		state_name = "Launching"

func enter(params : Dictionary = {}) -> void:
	super()

func doProcess(delta: float) -> PlayerState:
	return launched_state
