extends Node

# Base Stats
var base_launch_power : float = 2000
var base_bounce_force : float = 250.0
var base_forward_force : float = 100.0
var base_speed_boost_percentage: float = 0.1
var base_health : float = 10.0
var base_air_drag : float = 0.08
var base_ground_drag : float = 0.4

var base_attack_power : float = 0.0

# Upgrade Levels
var launch_power_level := 0
var bounce_force_level := 0
var forward_force_level := 0
var health_level := 0
var air_drag_level := 0
var ground_drag_level := 0
var attack_power_level := 0

# Current Values
var current_health : float = 0.0
var money : int = 500

# Scaling Constants
const POWER_STEP := 1.2
const DRAG_STEP := 0.9

func _ready():
	current_health = get_max_health()

func get_level(stat_name: String) -> int:
	match stat_name:
		Constants.HEALTH: return health_level
		Constants.LAUNCH: return launch_power_level
		Constants.BOUNCE_OFF: return bounce_force_level
		Constants.LAUNCH_OFF: return forward_force_level
		Constants.HEALTH_POTION: return health_level
		Constants.AIR_DRAG: return air_drag_level
		Constants.GROUND_DRAG: return ground_drag_level
		_: 
			push_warning("Unknown stat: %s" % stat_name)
			return 0

func upgrade(stat_name: String):
	match stat_name:
		Constants.HEALTH: 
			health_level += 1
			current_health += 1
		Constants.LAUNCH: launch_power_level += 1
		Constants.BOUNCE_OFF: bounce_force_level += 1
		Constants.LAUNCH_OFF: forward_force_level += 1
		Constants.AIR_DRAG: air_drag_level += 1
		Constants.GROUND_DRAG: ground_drag_level += 1

func consume(consumable_name: String):
	match consumable_name:
		Constants.HEALTH_POTION: 
			heal(get_max_health())

func spend_money(cost) -> bool:
	if money >= cost:
		money -= cost
		EventBus.emit_signal("money_changed", money)
		return true
	else:
		return false

func add_money(amount):
	money += amount
	EventBus.emit_signal("money_changed", money)

func get_money() -> int:
	return money

func get_launch_power() -> float:
	var launch_power = base_launch_power * pow(POWER_STEP, launch_power_level)
	return launch_power

func get_bounce_force() -> float:
	var bounce_force = base_bounce_force * pow(POWER_STEP, bounce_force_level)
	return bounce_force

func get_forward_force() -> float:
	var forward_force = base_forward_force * pow(POWER_STEP, forward_force_level)
	return forward_force

func get_speed_boost_percentage() -> float:
	var speed_boost = base_speed_boost_percentage * pow(1.1, forward_force_level)
	return speed_boost

func take_damage(damage):
	if current_health >= damage:
		current_health -= damage
	else:
		current_health = 0
	EventBus.emit_signal("health_changed", current_health)

func heal(amount):
	current_health += amount	
	if current_health > get_max_health():
		current_health = get_max_health()
	EventBus.emit_signal("health_changed",current_health)

func get_current_health() -> float:
	return current_health

func get_max_health() -> float:
	var health = base_health + health_level
	return health
	
func get_air_drag() -> float:
	var air_drag = base_air_drag * pow(DRAG_STEP, air_drag_level)
	return air_drag

func get_ground_drag() -> float:
	var ground_drag = base_ground_drag * pow(0.8, ground_drag_level)
	return ground_drag

func get_attack_modifier() -> float:
	var attack_mod = base_attack_power + float(attack_power_level)
	return attack_mod
