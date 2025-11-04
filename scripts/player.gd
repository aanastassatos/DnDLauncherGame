class_name Player
extends RigidBody2D

@onready var dice_label : Label = find_child("Dice")
@onready var visuals = find_child("GnomeSprite")
@onready var collision_ball = find_child("CollisionBall")
@onready var animation_player = find_child("AnimationPlayer")
@onready var state_label = $StateLabel

#States
@onready var state_machine = $StateMachine
@onready var idle_state = $StateMachine/Idle
@onready var launched_state = $StateMachine/Launched
@onready var landed_state = $StateMachine/Landed
@onready var dead_state = $StateMachine/Dead

@export var use_burrito_bison_physics = true

var aiming: bool = true
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

const IDLE : String = "idle"
const LAUNCHED : String = "launched"
const SLIDING : String = "sliding"
const ATTACK : String = "attack"
const HURT : String = "hurt"
const DEAD : String = "dead"
const LANDED : String = "landed"

func _ready():
	EventBus.enemy_hit.connect(_on_attack_success)
	EventBus.enemy_missed.connect(_on_attack_fail)
	state_machine.init(self)

	if use_burrito_bison_physics:
		var mat = physics_material_override
		contact_monitor = true
		max_contacts_reported = 1
		mat.friction = 0.0
	
	else:
		var mat = physics_material_override
		mat.friction = 0.1

func change_state(state : PlayerState):
	state_machine.change_state(state)

func update_state_label(player_state : String):
	state_label.text = player_state

func _process(delta):
	state_machine.doProcess(delta)
	
	if not state_machine.currentState.state_name == LAUNCHED:
		doIdleRotation(delta)

func doDiceRoll() -> void:
	if rolling_dice:
		dice_label.text = str(randi_range(1,20))

func doIdleRotation(delta : float) -> void:
	visuals.rotation = lerp_angle(visuals.rotation, 0, rotation_speed * delta)
	collision_ball.rotation = visuals.rotation

func doFlyingRotation(delta : float) -> void:
	if linear_velocity.length() > 10:
		var target_angle = linear_velocity.angle()+45
		visuals.rotation = lerp_angle(visuals.rotation, target_angle, rotation_speed * delta)
		collision_ball.rotation = visuals.rotation
	elif reset_rotation_on_ground:
		visuals.rotation = lerp_angle(visuals.rotation, 90, rotation_speed * delta)

func check_landed(delta : float) -> bool:
	if linear_velocity.length() < min_speed:
		still_time += delta
		sleeping = false
		if still_time > max_still_time: # been still for a second
			still_time = 0.0
			return true

	else:
		still_time = 0.0
	
	return false

func _on_body_entered(body):
	if body.is_in_group("ground"):
		touching_ground = true

func _on_body_exited(body):
	if body.is_in_group("ground"):
		touching_ground = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if state_machine.get_current_state() == LAUNCHED and use_burrito_bison_physics:
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
		forward_speed += speed_gained
	linear_velocity.y = -abs(linear_velocity.y)*0.9
	linear_velocity.x += forward_force
	var impulse = Vector2.UP * bounce_force# + Vector2.RIGHT * forward_force
	apply_impulse(impulse)

func launch(angle, power):
	var impulse = Vector2.RIGHT.rotated(deg_to_rad(angle)) * power
	forward_speed = impulse.x
	apply_impulse(impulse)
	change_state(launched_state)

func start_rolling_dice():
	rolling_dice = true
	
func stop_rolling_dice():
	rolling_dice = false

func freeze_player_for(duration, roll, hit : bool):
	stop_rolling_dice()
	update_dice(str(int(roll)))
	
	var big_size = 48
	var regular_size = 30
	var normal_color = Color.WHITE
	var highlight_color = Color.GREEN
	
	if not hit:
		highlight_color = Color.RED
	
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	
	var time_slow_scale = 0.05
	Engine.time_scale = time_slow_scale
	
	tween.tween_property(dice_label.label_settings, "font_size", big_size, 0.5*time_slow_scale).set_trans(Tween.TRANS_SINE)
	tween2.tween_property(dice_label.label_settings, "font_color", highlight_color, 0.5*time_slow_scale)
	
	await get_tree().create_timer(duration*time_slow_scale).timeout
	
	tween = create_tween()
	tween2 = create_tween() 
	
	Engine.time_scale = 1.0
	
	tween.tween_property(dice_label.label_settings, "font_size", regular_size, 0.5).set_trans(Tween.TRANS_SINE)
	tween2.tween_property(dice_label.label_settings, "font_color", normal_color, 0.5)
	
	await get_tree().create_timer(duration).timeout
	
	start_rolling_dice()

func update_dice(roll):
	dice_label.text = roll

func _on_attack_success():
	pass
	#var big_size = 48
	#var regular_size = 30
	#var normal_color = Color.WHITE
	#var highlight_color = Color.GREEN
	#
	#var tween = get_tree().create_tween()
	#var tween2 = get_tree().create_tween()
	#
	#tween.tween_property(dice_label.label_settings, "font_size", big_size, 0.5).set_trans(Tween.TRANS_SINE)
	#tween2.tween_property(dice_label.label_settings, "font_color", highlight_color, 0.5)
	#
	## Then shrink back and restore color
	#tween.tween_property(dice_label.label_settings, "font_size", regular_size, 0.5).set_trans(Tween.TRANS_SINE)
	#tween2.tween_property(dice_label.label_settings, "font_color", normal_color, 0.5)

func _on_attack_fail():
	pass

func stop_movement() -> void:
	linear_velocity = Vector2.ZERO
	stop_rolling_dice()
	if use_burrito_bison_physics:
		forward_speed = 0

func die():
	set_deferred("forward_speed", 0)
	set_deferred("linear_velocity.x", 0)
	change_state(dead_state)
