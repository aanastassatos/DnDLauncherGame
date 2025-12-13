class_name AttackResultState
extends PlayerState

@export var launched_state : PlayerState 
@export var attacking_state : PlayerState
@export var linger_duration : float = 0.6
@export var slow_time : bool = false

var slow_time_scale : float = 0.05
var elapsed : float = 0.0

var done_highlight : bool = false

var pending_next_state : PlayerState = null

func enter() -> void:
	super()
	if not EventBus.player_touched_enemy.is_connected(_on_player_touched_enemy):
		EventBus.player_touched_enemy.connect(_on_player_touched_enemy)
	
	elapsed = 0.0
	pending_next_state = null
	done_highlight = false
	parent.change_time_scale(slow_time_scale)
	parent.animation_player.speed_scale = 1.0/parent.current_time_scale
	doDiceHighlightAsync()

func exit() -> void:
	parent.animation_player.speed_scale = 1.0
	parent.change_time_scale(1.0)
	if EventBus.player_touched_enemy.is_connected(_on_player_touched_enemy):
		EventBus.player_touched_enemy.disconnect(_on_player_touched_enemy)

func _on_player_touched_enemy(enemy : Enemy) -> void:
	pending_next_state = attacking_state
	parent.last_enemy = enemy

func doProcess(delta: float) -> PlayerState:
	elapsed += delta
	if elapsed >= linger_duration*parent.current_time_scale and done_highlight:
		return launched_state
	return pending_next_state

func doDiceHighlightAsync() -> void:
	pass
