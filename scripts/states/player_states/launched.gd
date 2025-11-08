extends PlayerState

@export var landedState : PlayerState
@export var hit_state : PlayerState
@export var missedState : PlayerState
@export var dive_state : PlayerState

var pending_next_state : PlayerState = null

func _ready() -> void:
	if animation_name == "":
		animation_name = "flying"
	
	if state_name == "":
		state_name = parent.LAUNCHED

func enter() -> void:
	super()
	if not EventBus.enemy_hit.is_connected(_on_enemy_hit):
		EventBus.enemy_hit.connect(_on_enemy_hit)
	
	if not EventBus.enemy_missed.is_connected(_on_enemy_missed):
		EventBus.enemy_missed.connect(_on_enemy_missed)
	
	if not EventBus.dive_requested.is_connected(_on_dive_requested):
		EventBus.dive_requested.connect(_on_dive_requested)
		
	pending_next_state = null

func exit() -> void:
	super()
	if EventBus.enemy_hit.is_connected(_on_enemy_hit):
		EventBus.enemy_hit.disconnect(_on_enemy_hit)
	
	if EventBus.enemy_missed.is_connected(_on_enemy_missed):
		EventBus.enemy_missed.disconnect(_on_enemy_missed)
	
	if EventBus.dive_requested.is_connected(_on_dive_requested):
		EventBus.dive_requested.disconnect(_on_dive_requested)

func _on_enemy_hit(_enemy : Enemy) -> void:
	pending_next_state = hit_state

func _on_enemy_missed(_enemy : Enemy) -> void:
	print("enemy missed")
	pending_next_state = missedState

func _on_dive_requested() -> void:
	print("Dive requested")
	if parent.can_dive():
		pending_next_state = dive_state

func doProcess(delta: float) -> PlayerState:
	var newState : PlayerState = super(delta)
	
	parent.doDiceRoll()
	
	parent.doFlyingRotation(delta)
	
	if pending_next_state:
		return pending_next_state
	
	if parent.check_landed(delta):
		newState = landedState
	
	return newState
