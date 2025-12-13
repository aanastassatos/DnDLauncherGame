class_name Enemy
extends Area2D

@export var armor_class : int = 1
@export var damage : int = 1
@export var money_on_kill : int = 1

func _on_body_entered(body):
	if body.name == "Player":
		EventBus.emit_signal("player_touched_enemy", self)

func on_player_hit(player : Player) -> void:
	StatsManager.add_money(money_on_kill)
	EventBus.emit_signal("enemy_hit", self)
	print("HIT")
		
func on_player_missed(player : Player) -> void:
	StatsManager.take_damage(damage)
	EventBus.emit_signal("enemy_missed", self)
	print("OUCH")
