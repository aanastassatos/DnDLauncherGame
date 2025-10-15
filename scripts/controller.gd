extends Node2D

@onready var player = $Player
@onready var health_bar = $Player/HealthControl/HealthBar
@onready var aim_line = $AimLine
@onready var power_bar = $PowerBar
@onready var lines = $Lines
@onready var camera = $Player/Camera2D
@onready var hud = $HUD
@onready var enemySpawner = $EnemySpawner
@onready var debug_display = $Debug
@onready var stats_manager = $StatsManager

@export var launch_power : float = 2000
@export var friction : float = 0.1
@export var bounce_force : float = 500.0
@export var forward_force : float = 100.0

var health : float = 10.0
var max_health : float = 10.0
var power : float = 5000  

const AIMING : String = "aiming"
const LAUNCHING : String = "launching"
const LAUNCHED : String = "launched"
const LANDED : String = "landed"

var money : int = 0

var game_state : String = AIMING  # "aiming", "launching", "launched", "landed"

var starting_position : Vector2

func _ready():
	power_bar.hide()
	player.connect("landed", Callable(self, "_on_player_landed"))
	player.connect("launched", Callable(self, "_on_player_launched"))
	enemySpawner.player_hit_enemy.connect(_on_player_hit_enemy)
	starting_position = player.position
	hud.hide_middle_text(true)
	reset()

func _on_player_launched():
	print("launched")

func _on_player_landed():
	print("landed")
	game_state = LANDED
	hud.update_middle_text("Press SPACE to reset")
	hud.hide_middle_text(false)
	pass

func _on_player_hit_enemy(enemy):
	var roll = roll_dice() + stats_manager.get_attack_modifier()
	print("You rolled ",roll," against a level ", enemy.cr," enemy")
	if roll > enemy.cr:
		_launch_player_further()
		print("HIT")
	
	else:
		hurt_player(1)
		print("OUCH")
		
	await player.freeze_player_for(0.6, roll)

func roll_dice():
	randomize()
	var roll = randi_range(1, 20)
	#roll = 20
	return roll

func _launch_player_further():
	money += 1
	print(money)
	hud.update_money(money)
	player.bounce(stats_manager.get_bounce_force(), stats_manager.get_forward_force())

func hurt_player(damage):
	health -= damage
	print("health=",health," max_health=",max_health," health/max_health=",float(health/max_health))
	health_bar.value = float(float(health/max_health)*100)
	if health <= 0:
		player.die()
		game_state = LANDED
		
func heal_player(heal):
	health += heal

	if health > max_health:
		health = max_health

	health_bar.value = health/max_health*100

var aim_angle : float
var powerratio : float

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		match game_state:
			AIMING:
				doLaunching()
				
			LAUNCHING:
				doLaunched()
				
			LAUNCHED:
				pass
			
			LANDED:
				hud.hide_middle_text(true)
				reset()
			
func doLaunching():
	aim_line.stop()
	game_state = LAUNCHING
	aim_angle = aim_line.aim_angle
	start_launching()
	
func start_launching():
	#hud.update_middle_text("PRESS SPACE BITCH!!! (if you want)")
	power_bar.show() 
	power_bar.position = player.position
	power_bar.set_aim_angle(aim_angle)
	power_bar.start()
	
func doLaunched():
	game_state = LAUNCHED
	player.start_rolling_dice()
	hud.hide_middle_text(true)
	powerratio = power_bar.stop()
	aim_line.hide()
	power_bar.hide()
	player.freeze = false
	print("Launched at ", powerratio*100, "% power with value of ", launch_power*powerratio)
	player.launch(aim_angle, stats_manager.get_launch_power()*powerratio)
	camera.doLaunched()

func reset():
	enemySpawner.reset_enemies()
	#hud.update_middle_text("Press SPACEBAR to launch")
	#hud.hide_middle_text(false)
	player.position = starting_position
	player.freeze = true
	aim_line.show()
	aim_line.start()
	camera.doAiming()
	game_state = AIMING
	heal_player(max_health)

func _process(delta):
	match game_state:
		AIMING:
			aim_line.position = player.position
			_update_aiming(delta)
		LAUNCHING:
			_update_launching(delta)
		LAUNCHED:
			_update_launched(delta)
		LANDED:
			_update_landed(delta)
			

func _update_aiming(delta):
	pass

func _update_launching(delta):
	pass

func _update_launched(delta):
	var distance = player.global_position.x - starting_position.x
	var distance_in_meters = distance/lines.PIXELS_PER_METER
	hud.update_distance(distance_in_meters)
	hud.update_linear_velocity(player.linear_velocity)
	pass

func _update_landed(delta):
	#Can display reset prompt, store score, and reset UI here
	pass
