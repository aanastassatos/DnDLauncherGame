extends PlayerState

@export var landedState : PlayerState
@export var hit_state : PlayerState
@export var missedState : PlayerState

var pending_next_state : PlayerState = null

func _ready() -> void:
	if animation_name == "":
		animation_name = "flying"
	
	if state_name == "":
		state_name = parent.LAUNCHED

func enter() -> void:
	super()
	EventBus.emit_signal("player_launched")
	
	if not EventBus.enemy_hit.is_connected(_on_enemy_hit):
		EventBus.enemy_hit.connect(_on_enemy_hit)
	
	if not EventBus.enemy_missed.is_connected(_on_enemy_missed):
		EventBus.enemy_missed.connect(_on_enemy_missed)
		
	pending_next_state = null

func exit() -> void:
	super()
	if EventBus.enemy_hit.is_connected(_on_enemy_hit):
		EventBus.enemy_hit.disconnect(_on_enemy_hit)
	
	if EventBus.enemy_missed.is_connected(_on_enemy_missed):
		EventBus.enemy_missed.disconnect(_on_enemy_missed)

func _on_enemy_hit(enemy : Enemy) -> void:
	pending_next_state = hit_state

func _on_enemy_missed(enemy : Enemy) -> void:
	print("enemy missed")
	pending_next_state = missedState

func doProcess(delta: float) -> PlayerState:
	var newState : PlayerState = super(delta)
	
	parent.doDiceRoll()
	
	parent.doFlyingRotation(delta)
	
	if pending_next_state:
		return pending_next_state
	
	if parent.check_landed(delta):
		newState = landedState
	
	return newState
