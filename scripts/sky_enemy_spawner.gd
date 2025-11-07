extends Node2D

@export var enemy_scene : PackedScene
@export var camera: Camera2D
@export var chunk_width: float = 2000.0
@export var enemies_per_chunk: int = 3
@export var y_range: Vector2 = Vector2(-300, -1000)
@export var ground_y : float = 70
@export var enabled : bool = true

const MAX_DISTANCE = 2000
var last_spawn_x : float =0.0
var enemies : Array = []

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
		var valid_position = false
		var attempt = 0
		var position: Vector2
		var offset_x = 0.0
		var offset_y = 0.0

		while not valid_position and attempt < tries_per_enemy:
			attempt += 1
			offset_x = randf_range(-chunk_width / 2, chunk_width / 2)
			offset_y = randf_range(y_range.x, y_range.y)
			position = Vector2(center_x + offset_x, offset_y)

			valid_position = true
			for e in enemies_in_chunk:
				if e.position.distance_to(position) < enemy_spacing:
					valid_position = false
					break

		if valid_position:
			var enemy = enemy_scene.instantiate()
			
			# Try to align with ground based on collider
			var collider = enemy.get_node_or_null("CollisionShape2D")
			if collider and collider.shape is RectangleShape2D:
				var rect_shape = collider.shape
				var collider_bottom = rect_shape.extents.y
				var shape_offset = collider.position.y
				enemy.position = Vector2(center_x + offset_x, offset_y - collider_bottom - shape_offset)
			else:
				enemy.position = Vector2(center_x + offset_x, offset_y)

			enemies.append(enemy)
			enemies_in_chunk.append(enemy)
			add_child(enemy)
		else:
			print("Could not find valid position for enemy after", tries_per_enemy, "tries")

func clear_far_enemies(player_x: float):
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.position.x < player_x - MAX_DISTANCE:
			enemy.queue_free()
			enemies.erase(enemy)

func reset_enemies():
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	
	enemies.clear()
	last_spawn_x = 0.0
