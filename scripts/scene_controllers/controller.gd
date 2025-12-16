extends Node2D

@onready var furthest_distance_sign : FurthestDistanceSign = $FurthestDistanceSign

@onready var player : Player = $Player
@onready var lines = $Lines
@onready var camera = $Player/Camera2D
@onready var hud = $HUD
@onready var enemySpawner = $EnemySpawner
@onready var skyEnemySpawner = $SkyEnemySpawner
@onready var store = $Store
@onready var store_button = find_child("StoreButton", true, false)

const AIMING : String = "aiming"
const LAUNCHING : String = "launching"
const LAUNCHED : String = "launched"
const LANDED : String = "landed"

var game_state : String = AIMING  # "aiming", "launching", "launched", "landed"

var furthest_distance : float = 0.0

func _ready():
	store.hide_store()
	EventBus.player_landed.connect(_on_player_landed)
	EventBus.player_launched.connect(_on_player_launched)
	EventBus.player_died.connect(_on_player_died)
	store_button.pressed.connect(_on_store_opened)
	EventBus.store_closed.connect(_on_store_closed)
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
	check_furthest_distance()
	hud.update_middle_text("Press SPACE to reset")
	hud.hide_middle_text(false)
	find_child("StoreButton", true, false).show()
	pass

func check_furthest_distance() -> void:
	if player.position.x >= RunManager.get_furthest_distance_in_pixels():
		furthest_distance = player.position.x
		furthest_distance_sign.set_futhest_distance(player.position.x)
		

func _on_player_died():
	player.die()
	print("died")
	game_state = LANDED

func hurt_player(damage):
	StatsManager.take_damage(damage)

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
	game_state = LAUNCHING
	start_launching()
	
func start_launching():
	pass
	
func doLaunched():
	game_state = LAUNCHED
	player.start_rolling_dice()
	hud.hide_middle_text(true)
	camera.doLaunched()

func reset():
	enemySpawner.reset_enemies()
	skyEnemySpawner.reset_enemies()
	#hud.update_middle_text("Press SPACEBAR to launch")
	#hud.hide_middle_text(false)
	player.do_reset()
	camera.doAiming()
	game_state = AIMING

func _process(delta):
	match game_state:
		AIMING:
			pass
		LAUNCHING:
			_update_launching(delta)
		LAUNCHED:
			_update_launched(delta)
		LANDED:
			_update_landed(delta)
			

func _update_launching(delta):
	pass

func _update_launched(delta):
	var distance = player.global_position.x - player.starting_position.x
	RunManager.update_distance(distance)
	hud.update_linear_velocity(player.linear_velocity)
	hud.update_forward_speed(player.forward_speed)
	pass

func _update_landed(delta):
	#Can display reset prompt, store score, and reset UI here
	pass
