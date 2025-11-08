extends PlayerState

@export var launched_state : PlayerState
@export var hit_state : PlayerState
@export var missedState : PlayerState

var pending_next_state  : PlayerState = null

var dive_force : float = 1200.0

func _ready() -> void:
	if animation_name == "":
		animation_name = "Sliding"
	
	if state_name == "":
		state_name = parent.DIVE

func enter() -> void:
	super()
	if not EventBus.enemy_hit.is_connected(_on_enemy_hit):
		EventBus.enemy_hit.connect(_on_enemy_hit)
	
	if not EventBus.enemy_missed.is_connected(_on_enemy_missed):
		EventBus.enemy_missed.connect(_on_enemy_missed)
	
	pending_next_state = null
	
	var velocity = parent.linear_velocity
	print("Linear velocity before dive: "+str(velocity))
	parent.linear_velocity.y = dive_force
	print("Linear velocity after dive: "+str(parent.linear_velocity))

func exit() -> void:
	if EventBus.enemy_hit.is_connected(_on_enemy_hit):
		EventBus.enemy_hit.disconnect(_on_enemy_hit)
	
	if EventBus.enemy_missed.is_connected(_on_enemy_missed):
		EventBus.enemy_missed.disconnect(_on_enemy_missed)
	pass

func _on_enemy_hit(enemy : Enemy) -> void:
	pending_next_state = hit_state

func _on_enemy_missed(enemy : Enemy) -> void:
	pending_next_state = missedState

func doProcess(delta: float) -> PlayerState:
	parent.doIdleRotation(delta)
	
	parent.dive_ability.current_cooldown = parent.dive_ability.cooldown
	
	if parent.touching_ground:
		return launched_state
	
	return pending_next_state
