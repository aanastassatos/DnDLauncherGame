extends PlayerState

@export
var launched_state : PlayerState

func _ready():
	if animation_name == "":
		animation_name = "flying"
	
	if state_name == "":
		state_name = parent.LAUNCHING

func enter() -> void:
	super()

func doProcess(delta: float) -> PlayerState:
	parent.do_launch()
	return launched_state

func exit() -> void:
	EventBus.emit_signal("player_launched")
