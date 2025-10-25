extends Node2D

@onready var player = $Player
@onready var health_bar = $Player/HealthControl/HealthBar
@onready var aim_line = $AimLine
@onready var power_bar = $PowerBar
@onready var lines = $Lines
@onready var camera = $Player/Camera2D
@onready var hud = $HUD
@onready var enemySpawner = $EnemySpawner
@onready var store = $Store
@onready var store_button = find_child("StoreButton", true, false)

const AIMING : String = "aiming"
const LAUNCHING : String = "launching"
const LAUNCHED : String = "launched"
const LANDED : String = "landed"

var game_state : String = AIMING  # "aiming", "launching", "launched", "landed"

var starting_position : Vector2

func _ready():
	power_bar.hide()
	store.hide_store()
	EventBus.player_landed.connect(_on_player_landed)
	EventBus.player_launched.connect(_on_player_launched)
	EventBus.player_died.connect(_on_player_died)
	EventBus.player_touched_enemy.connect(_on_player_hit_enemy)
	store_button.pressed.connect(_on_store_opened)
	EventBus.store_closed.connect(_on_store_closed)
	EventBus.health_changed.connect(_update_health)
	starting_position = player.position
	hud.hide_middle_text(true)
	reset()

func _on_store_opened():
	store.show_store()
	get_tree().paused = true
	hud.hide()
	EventBus.emit_signal("store_opened")

func _on_store_closed():
	store.hide_store()
	get_tree().paused = false
	hud.show()

func _on_player_launched():
	find_child("StoreButton", true, false).hide()
	print("launched")

func _on_player_landed():
	print("landed")
	game_state = LANDED
	hud.update_middle_text("Press SPACE to reset")
	hud.hide_middle_text(false)
	find_child("StoreButton", true, false).show()
	pass

func _on_player_hit_enemy(enemy):
	var roll = roll_dice() + StatsManager.get_attack_modifier()
	print("You rolled ",roll," against a level ", enemy.cr," enemy")
	if roll > enemy.cr:
		_launch_player_further()
		EventBus.emit_signal("enemy_hit")
		print("HIT")
	
	else:
		hurt_player(1)
		print("OUCH")
		
	await player.freeze_player_for(0.6, roll)

func _on_player_died():
	player.die()
	print("died")
	game_state = LANDED

func roll_dice():
	randomize()
	var roll = randi_range(1, 20)
	#roll = 20
	return roll

func _launch_player_further():
	StatsManager.add_money(1)
	print(StatsManager.money)
	player.bounce(StatsManager.get_bounce_force(), StatsManager.get_forward_force())

func hurt_player(damage):
	StatsManager.take_damage(damage)

func _update_health(health):
	print("health changed")
	health_bar.value = float((StatsManager.get_current_health()/StatsManager.get_max_health())*100)

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
	print("Launched at ", powerratio*100, "% power with value of ", StatsManager.get_launch_power()*powerratio)
	player.launch(aim_angle, StatsManager.get_launch_power()*powerratio)
	camera.doLaunched()

func reset():
	enemySpawner.reset_enemies()
	#hud.update_middle_text("Press SPACEBAR to launch")
	#hud.hide_middle_text(false)
	player.position = starting_position
	player.freeze = true
	player.linear_velocity = Vector2.ZERO
	player.angular_velocity = 0
	player.sleeping = false
	player.set_deferred("position", starting_position)
	player.set_deferred("touching_ground", false )
	
	aim_line.show()
	aim_line.start()
	camera.doAiming()
	game_state = AIMING

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
