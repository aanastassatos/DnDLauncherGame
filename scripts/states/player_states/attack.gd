extends PlayerState

@export var launched_state : PlayerState 
@export var linger_duration : float = 0.6

var slow_time_scale : float = 0.05
var elapsed : float = 0.0

var done_highlight : bool = false

func _ready() -> void:
	if animation_name == "" or state_name == null:
		animation_name = "Sliding"
	
	if state_name == "" or state_name == null:
		state_name = parent.ATTACK

func enter() -> void:
	super()
	elapsed = 0.0
	done_highlight = false
	parent.change_time_scale(slow_time_scale)
	parent.doBounce()
	doDiceHighlightAsync()

func doProcess(delta: float) -> PlayerState:
	elapsed += delta
	if elapsed >= linger_duration*slow_time_scale and done_highlight:
		return launched_state
	return null

func exit() -> void:
	parent.change_time_scale(1.0)

func doDiceHighlightAsync() -> void:
	await parent.doDiceHighlight(0.6, parent.last_roll, true)
	done_highlight = true
