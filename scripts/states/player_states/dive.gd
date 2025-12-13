extends PlayerState

@export var launched_state : PlayerState
@export var attacking_state : PlayerState

var pending_next_state  : PlayerState = null

var dive_force : float = 1200.0

func _ready() -> void:
	if animation_name == "":
		animation_name = "Sliding"
	
	if state_name == "":
		state_name = parent.DIVE

func enter() -> void:
	super()
	if not EventBus.player_touched_enemy.is_connected(_on_player_touched_enemy):
		EventBus.player_touched_enemy.connect(_on_player_touched_enemy)
	
	pending_next_state = null
	
	var velocity = parent.linear_velocity
	print("Linear velocity before dive: "+str(velocity))
	parent.linear_velocity.y = dive_force
	print("Linear velocity after dive: "+str(parent.linear_velocity))

func exit() -> void:
	if EventBus.player_touched_enemy.is_connected(_on_player_touched_enemy):
		EventBus.player_touched_enemy.disconnect(_on_player_touched_enemy)
	
	parent.bounce_from_dive = true
	pass

func _on_player_touched_enemy(enemy : Enemy) -> void:
	pending_next_state = attacking_state
	parent.last_enemy = enemy

func doProcess(delta: float) -> PlayerState:
	parent.doIdleRotation(delta)
	
	parent.dive_ability.current_cooldown = parent.dive_ability.cooldown
	
	if parent.touching_ground:
		return launched_state
	
	return pending_next_state
