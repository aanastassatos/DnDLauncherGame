extends Node2D

# Base Stats
@export var base_launch_power : float = 2000
@export var base_bounce_force : float = 500.0
@export var base_forward_force : float = 100.0
@export var base_health : float = 10.0
@export var base_air_drag : float = 0.02
@export var base_ground_drag : float = 0.05

@export var base_attack_power : float = 0.0

# Upgrade Levels
@export var launch_power_level := 0
@export var bounce_force_level := 0
@export var forward_force_level := 0
@export var health_level := 0
@export var air_drag_level := 0
@export var ground_drag_level := 0
@export var attack_power_level := 0

# Scaling Constants
const POWER_STEP := 1.2
const DRAG_STEP := 0.9

func get_launch_power() -> float:
	var launch_power = base_launch_power * pow(POWER_STEP, launch_power_level)
	print("Launch power: ", launch_power)
	return launch_power

func get_bounce_force() -> float:
	var bounce_force = base_bounce_force * pow(POWER_STEP, bounce_force_level)
	print("Bounce force: ", bounce_force)
	return bounce_force

func get_forward_force() -> float:
	var forward_force = base_forward_force * pow(POWER_STEP, forward_force_level)
	print("Forward force: ", forward_force)
	return forward_force

func get_health() -> float:
	var health = base_health + health_level
	print("Health: ", health)
	return health
	
func get_air_drag() -> float:
	var air_drag = base_air_drag * pow(DRAG_STEP, air_drag_level)
	return air_drag

func get_ground_drag() -> float:
	var ground_drag = base_ground_drag * pow(DRAG_STEP, ground_drag_level)
	return ground_drag

func get_attack_modifier() -> float:
	var attack_mod = base_attack_power + float(attack_power_level)
	return attack_mod
