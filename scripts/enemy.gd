class_name Enemy
extends Area2D

@onready var level_label = $Control/Panel/Level

var cr : int = 4

func _ready():
	level_label.text = str(cr)

func _on_body_entered(body):
	if body.name == "Player":
		EventBus.emit_signal("player_touched_enemy", self)
