extends Node

@export var startingState: PlayerState

var currentState: PlayerState
var previousState: PlayerState

func init(parent: Player) -> void:
	for child in get_children():
		child.parent = parent
	
	change_state(startingState, {})

func change_state(newState: PlayerState, params : Dictionary = {}) -> void:
	if currentState:
		currentState.exit()
		previousState = currentState
	
	currentState = newState
	currentState.enter(params)

func doProcess(delta: float) -> void:
	var newState = currentState.doProcess(delta)
	if newState:
		change_state(newState)

func get_current_state() -> String:
	return currentState.state_name
