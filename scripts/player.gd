extends RigidBody2D

@onready var dice_label = find_child("Dice")
@onready var visuals = find_child("GnomeSprite")
@onready var collision_ball = find_child("CollisionBall")
@onready var animation_player = find_child("AnimationPlayer")
@export var use_burrito_bison_physics = true

var aiming: bool = true
var flying: bool = false
var rolling_dice: bool = false
var aim_angle: float = -45
var min_angle: float = 0.0
var max_angle: float = 85.0
var swing_speed : float = 90.0
var swinging_down : bool = true
var last_position : Vector2

var min_speed : float = 10.0
var max_still_time:=0.5

var still_time:=0.0

var forward_speed : float = 200.0
var touching_ground: bool = false

var rotation_speed : float = 8.0
var reset_rotation_on_ground : bool = true

func _ready():
	if use_burrito_bison_physics:
		var mat = physics_material_override
		contact_monitor = true
		max_contacts_reported = 1
		body_entered.connect(_on_body_entered)
		body_exited.connect(_on_body_exited)
		mat.friction = 0.0
	
	else:
		var mat = physics_material_override
		mat.friction = 0.1

func _process(delta):
	if flying:
		if linear_velocity.length() < min_speed:
			still_time += delta
			sleeping = false
			if still_time > max_still_time: # been still for a second
				still_time = 0.0
				do_landed()

		else:
			still_time = 0.0
			
	if rolling_dice:
		dice_label.text = str(randi_range(1,20))
	
	if flying:
		if linear_velocity.length() > 10:
			var target_angle = linear_velocity.angle()+45
			visuals.rotation = lerp_angle(visuals.rotation, target_angle, rotation_speed * delta)
			collision_ball.rotation = visuals.rotation
		elif reset_rotation_on_ground:
			visuals.rotation = lerp_angle(visuals.rotation, 90, rotation_speed * delta)
	
	if not flying:
		visuals.rotation = lerp_angle(visuals.rotation, 0, rotation_speed * delta)
		collision_ball.rotation = visuals.rotation

func do_landed():
	linear_velocity = Vector2.ZERO
	flying = false
	stop_rolling_dice()
	if use_burrito_bison_physics:
		forward_speed = 0
	
	EventBus.emit_signal("player_landed")
	animation_player.play("Idle")

func _on_body_entered(body):
	if body.is_in_group("ground"):
		touching_ground = true

func _on_body_exited(body):
	if body.is_in_group("ground"):
		touching_ground = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if flying and use_burrito_bison_physics:
		forward_speed *= 1.0 - StatsManager.get_air_drag() * state.step
		
		if touching_ground:
			var speed_loss = forward_speed*StatsManager.get_ground_drag()
			
			if forward_speed - speed_loss > 0:
				forward_speed -= speed_loss
			
			else:
				forward_speed = 0
			
		var velocity = state.linear_velocity
		velocity.x = forward_speed
		state.linear_velocity = velocity

func bounce(bounce_force, forward_force):
	if use_burrito_bison_physics:
		var speed_gained = forward_speed*StatsManager.get_speed_boost_percentage()
	linear_velocity.y = -abs(linear_velocity.y)*0.9
	linear_velocity.x += forward_force
	var impulse = Vector2.UP * bounce_force# + Vector2.RIGHT * forward_force
	apply_impulse(impulse)

func launch(angle, power):
	flying = true
	var impulse = Vector2.RIGHT.rotated(deg_to_rad(angle)) * power
	forward_speed = impulse.x
	apply_impulse(impulse)
	EventBus.emit_signal("player_launched")
	animation_player.play("flying")
	

func start_rolling_dice():
	rolling_dice = true
	
func stop_rolling_dice():
	rolling_dice = false

func freeze_player_for(duration, roll):
	stop_rolling_dice()
	update_dice(str(int(roll)))
	
	var time_slow_scale = 0.05
	Engine.time_scale = time_slow_scale
	
	await get_tree().create_timer(duration*time_slow_scale).timeout
	
	Engine.time_scale = 1.0
	start_rolling_dice()

func update_dice(roll):
	dice_label.text = roll

func die():
	set_deferred("forward_speed", 0)
	set_deferred("linear_velocity.x", 0)
	do_landed()
