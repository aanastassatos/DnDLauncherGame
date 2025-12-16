extends Enemy

@onready var level_label = $Control/Panel/Level

const DRAGON_AC : int = 8
const DRAGON_DAMAGE : int = 2
const DRAGON_MONEY : int = 10

@export var health : int = 3
@export var player : Player
@export var lerp_speed : float = 10.0

var current_distance : float = 800.0
var target_distance : float = 800.0
var alive : bool = true

func _ready() -> void:
	armor_class = DRAGON_AC
	damage = DRAGON_DAMAGE
	money_on_kill = DRAGON_MONEY
	EventBus.enemy_hit.connect(on_player_hit_enemy)
	
	level_label.text = str(armor_class)

func _process(delta: float) -> void:
	if alive:
		current_distance = lerp(current_distance, target_distance, lerp_speed*delta)
		
		if player:
			position.x = player.position.x + current_distance

func _on_body_entered(body):
	if body.name == "Player":
		EventBus.emit_signal("player_touched_enemy", self)

func on_player_hit_enemy(_enemy : Enemy) -> void:
	if alive:
		target_distance -= 200

func on_player_hit(player : Player) -> void:
	health -= 1
	
	if health == 0:
		print("WIN!")
		alive = false
	
	else:
		target_distance = 800.0
		EventBus.emit_signal("enemy_hit", self)
		print("HIT")
	
func on_player_missed(player : Player) -> void:
	target_distance = 800.0
	StatsManager.take_damage(damage)
	EventBus.emit_signal("enemy_missed", self)
	print("OUCH")
