extends Node2D

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

func _ready():
	store.hide_store()
	EventBus.player_landed.connect(_on_player_landed)
	EventBus.player_launched.connect(_on_player_launched)
	EventBus.player_died.connect(_on_player_died)
	EventBus.player_touched_enemy.connect(_on_player_hit_enemy)
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
	hud.update_middle_text("Press SPACE to reset")
	hud.hide_middle_text(false)
	find_child("StoreButton", true, false).show()
	pass

func _on_player_hit_enemy(enemy):
	var roll = roll_dice() + StatsManager.get_attack_modifier()
	if roll > enemy.cr:
		StatsManager.add_money(1)
		print(StatsManager.money)
		EventBus.emit_signal("enemy_hit", enemy)
		print("HIT")
	#
	else:
		hurt_player(1)
		EventBus.emit_signal("enemy_missed", enemy)
		print("OUCH")
	

func _on_player_died():
	player.die()
	print("died")
	game_state = LANDED

func roll_dice() -> int:
	return player.get_roll()

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
	
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_Z:
			print("The Z")
			EventBus.emit_signal("dive_requested")
		if event.keycode == KEY_X:
			print("The X")
			EventBus.emit_signal("slide_requested")

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
	var distance_in_meters = distance/lines.PIXELS_PER_METER
	hud.update_distance(distance_in_meters)
	hud.update_linear_velocity(player.linear_velocity)
	hud.update_forward_speed(player.forward_speed)
	pass

func _update_landed(delta):
	#Can display reset prompt, store score, and reset UI here
	pass
