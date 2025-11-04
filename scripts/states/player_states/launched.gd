extends PlayerState

@export
var landedState : PlayerState

var still_time : float = 0.0

func _ready() -> void:
	if animation_name == "":
		animation_name = "flying"
	
	if state_name == "":
		state_name = parent.LAUNCHED

func enter() -> void:
	super()
	EventBus.emit_signal("player_launched")

func doProcess(delta: float) -> PlayerState:
	var newState : PlayerState = super(delta)
	
	parent.doDiceRoll()
	
	if parent.check_landed(delta):
		newState = landedState
	
	parent.doFlyingRotation(delta)
	
	return newState
