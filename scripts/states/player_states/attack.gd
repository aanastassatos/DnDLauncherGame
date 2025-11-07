class_name AttackState
extends PlayerState

@export var launched_state : PlayerState 
@export var linger_duration : float = 0.6
@export var slow_time : bool = false

var slow_time_scale : float = 0.05
var elapsed : float = 0.0

var done_highlight : bool = false

func enter() -> void:
	super()
	elapsed = 0.0
	done_highlight = false
	parent.change_time_scale(slow_time_scale)
	parent.animation_player.speed_scale = 1.0/parent.current_time_scale
	doDiceHighlightAsync()

func doProcess(delta: float) -> PlayerState:
	elapsed += delta
	if elapsed >= linger_duration*parent.current_time_scale and done_highlight:
		return launched_state
	return null

func exit() -> void:
	parent.animation_player.speed_scale = 1.0
	parent.change_time_scale(1.0)

func doDiceHighlightAsync() -> void:
	pass
