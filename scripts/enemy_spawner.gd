extends Node2D

@export var enemy_scene : PackedScene
@export var camera: Camera2D
@export var chunk_width: float = 2000.0
@export var enemies_per_chunk: int = 3
@export var y_range: Vector2 = Vector2(-200, -50)
@export var y : float = 70.0
@export var enabled : bool = true

const MAX_DISTANCE = 2000
var last_spawn_x : float =0.0
var enemies : Array = []

signal player_hit_enemy(enemy)

func _process(delta):
	if not camera:
		return
		
	var camera_x = camera.global_position.x
	var camera_right_edge  = camera_x + (camera.get_viewport_rect().size.x/2)
	
	if camera_right_edge > last_spawn_x and enabled:
		spawn_enemies(last_spawn_x + chunk_width)
		last_spawn_x += chunk_width
	
	clear_far_enemies(camera_x)

var enemy_spacing = 80
var tries_per_enemy : int=10

func spawn_enemies(center_x: float):
	var enemies_in_chunk: Array = []

	for i in range(enemies_per_chunk):
		var enemy = enemy_scene.instantiate()
		var valid_position = false
		var attempt = 0
		var position: Vector2

		while not valid_position and attempt < tries_per_enemy:
			attempt += 1
			var offset_x = randf_range(-chunk_width / 2, chunk_width / 2)
			position = Vector2(center_x + offset_x, y)

			valid_position = true
			for e in enemies_in_chunk:
				if e.position.distance_to(position) < enemy_spacing:
					valid_position = false
					break

		if valid_position:
			enemy.position = position
			enemy.hit_by_player.connect(_notify_player_hit)
			enemies.append(enemy)
			enemies_in_chunk.append(enemy)
			add_child(enemy)
		else:
			print("⚠️ Could not find valid position for enemy after", tries_per_enemy, "tries")

func clear_far_enemies(player_x: float):
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.position.x < player_x - MAX_DISTANCE:
			enemy.queue_free()
			enemies.erase(enemy)
			print("Enemy Despawned")

func _notify_player_hit(enemy):
	emit_signal("player_hit_enemy", enemy)

func reset_enemies():
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	
	enemies.clear()
	last_spawn_x = 0.0
