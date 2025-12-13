extends PlayerState

@export var hit_state : PlayerState
@export var miss_state : PlayerState 

var enemy : Enemy

func _ready() -> void:
	if animation_name == "":
		animation_name = "flying"
	
	if state_name == "":
		state_name = parent.ATTACKING

func enter() -> void:
	enemy = parent.last_enemy

func exit() -> void:
	pass

func doProcess(delta: float) -> PlayerState:
	var roll = roll_dice() + StatsManager.get_attack_modifier()
	if roll > enemy.armor_class:
		enemy.on_player_hit(parent)
		return hit_state
		
	else:
		enemy.on_player_missed(parent)
		return miss_state

func roll_dice() -> int:
	return parent.get_roll()
