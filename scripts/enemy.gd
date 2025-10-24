extends Area2D

@onready var level_label = $Control/Panel/Level

signal hit_by_player(enemy)

var cr : int = 4

func _ready():
	level_label.text = str(cr)

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("hit_by_player", self)
