class_name AttackState
extends PlayerState

@export var launched_state : PlayerState 
@export var hit_state : PlayerState
@export var miss_state : PlayerState 
@export var linger_duration : float = 0.6
@export var slow_time : bool = false

var slow_time_scale : float = 0.05
var elapsed : float = 0.0

var done_highlight : bool = false

var pending_next_state : PlayerState = null

func enter() -> void:
	super()
	if not EventBus.enemy_hit.is_connected(_on_enemy_hit):
		EventBus.enemy_hit.connect(_on_enemy_hit)
	
	if not EventBus.enemy_missed.is_connected(_on_enemy_missed):
		EventBus.enemy_missed.connect(_on_enemy_missed)
	elapsed = 0.0
	pending_next_state = null
	done_highlight = false
	parent.change_time_scale(slow_time_scale)
	parent.animation_player.speed_scale = 1.0/parent.current_time_scale
	doDiceHighlightAsync()

func exit() -> void:
	parent.animation_player.speed_scale = 1.0
	parent.change_time_scale(1.0)
	if EventBus.enemy_hit.is_connected(_on_enemy_hit):
		EventBus.enemy_hit.disconnect(_on_enemy_hit)
	
	if EventBus.enemy_missed.is_connected(_on_enemy_missed):
		EventBus.enemy_missed.disconnect(_on_enemy_missed)

func _on_enemy_hit(enemy : Enemy) -> void:
	pending_next_state = hit_state

func _on_enemy_missed(enemy : Enemy) -> void:
	print("enemy missed")
	pending_next_state = miss_state

func doProcess(delta: float) -> PlayerState:
	elapsed += delta
	if elapsed >= linger_duration*parent.current_time_scale and done_highlight:
		return launched_state
	return pending_next_state

func doDiceHighlightAsync() -> void:
	pass
