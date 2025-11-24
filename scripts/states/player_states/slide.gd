extends PlayerState

@export var hit_state : PlayerState
@export var missed_state : PlayerState
@export var launched_state: PlayerState

@export var slide_duration: float = 3.0
@export var bounce_force: float = 600.0

var pending_next_state : PlayerState = null

var starting_velocity_y : float = 0.0

var _elapsed: float = 0.0

func _ready() -> void:
	if animation_name == "":
		animation_name = "Sliding"
	
	if state_name == "":
		state_name = parent.SLIDE

func enter() -> void:
	super()
	
	if not EventBus.enemy_hit.is_connected(_on_enemy_hit):
		EventBus.enemy_hit.connect(_on_enemy_hit)
	
	if not EventBus.enemy_missed.is_connected(_on_enemy_missed):
		EventBus.enemy_missed.connect(_on_enemy_missed)
	
	_elapsed = 0.0
	pending_next_state = null
	
	var k : float = 0.4
	
	#Stop vertical velocity, but save the previous bounce velocity
	starting_velocity_y = -abs(parent.linear_velocity.y)
	parent.linear_velocity.y = 0.0
	parent.forward_speed += abs(k*starting_velocity_y)
	parent.set_ground_friction_enabled(false)
	parent.set_air_friction_enabled(false)
	parent.set_bounce_enabled(false)

func exit() -> void:
	# Restore normal physics when leaving this state
	if EventBus.enemy_hit.is_connected(_on_enemy_hit):
		EventBus.enemy_hit.disconnect(_on_enemy_hit)
	
	if EventBus.enemy_missed.is_connected(_on_enemy_missed):
		EventBus.enemy_missed.disconnect(_on_enemy_missed)
	
	parent.linear_velocity.y = starting_velocity_y
	
	if _elapsed < 0.1:
		parent.slide_ability.current_cooldown = 0.0
	
	parent.set_ground_friction_enabled(true)
	parent.set_air_friction_enabled(true)
	parent.set_bounce_enabled(true)

func _on_enemy_hit(_enemy : Enemy) -> void:
	pending_next_state = hit_state

func _on_enemy_missed(_enemy : Enemy) -> void:
	pending_next_state = missed_state

func doProcess(delta: float) -> PlayerState:
	_elapsed += delta
	parent.doSlideRotation(delta)
	parent.slide_ability.current_cooldown = parent.slide_ability.cooldown
	
	if pending_next_state != null:
		return pending_next_state
	
	# When timer runs out, transition to bounce
	if _elapsed >= slide_duration:
		return launched_state
	return null
