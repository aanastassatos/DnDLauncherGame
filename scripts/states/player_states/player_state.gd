class_name PlayerState
extends Node

@export
var animation_name: String = ""

@export
var state_name : String = ""

var parent: Player

func enter() -> void:
	parent.animation_player.play(animation_name)

func exit() -> void:
	pass

func doProcess(delta: float) -> PlayerState:
	return null
