class_name Player
extends RigidBody2D

@onready var dice_label : Label = find_child("Dice")
@onready var visuals = find_child("GnomeSprite")
@onready var collision_ball = find_child("CollisionBall")
@onready var animation_player = find_child("AnimationPlayer")
@onready var aim_and_power : AimAndPower = $Aim_And_Power
@onready var state_label = $StateLabel

#States
@onready var state_machine = $StateMachine
@onready var idle_state = $StateMachine/Idle
@onready var launched_state = $StateMachine/Launched
@onready var landed_state = $StateMachine/Landed
@onready var dead_state = $StateMachine/Dead

@export var dive_ability : Ability

@export var use_burrito_bison_physics = true

var starting_position : Vector2

var aiming: bool = true
var rolling_dice: bool = false
var last_roll : int

var min_speed : float = 10.0
var max_speed : float = 10000
var max_still_time:=0.5

var still_time:=0.0

var current_time_scale : float = 1.00

var forward_speed : float = 0.0
var touching_ground: bool = false

var rotation_speed : float = 8.0
var reset_rotation_on_ground : bool = true

const IDLE : String = "idle"
const AIMING : String = "aiming"
const POWERING_UP : String = "powering_up"
const LAUNCHING : String = "launching"
const LAUNCHED : String = "launched"
const ATTACK : String = "attack"
const MISS : String = "miss"
const HURT : String = "hurt"
const DIVE : String = "dive"
const SLIDE : String = "slide"
const DEAD : String = "dead"
const LANDED : String = "landed"

func _ready():
	EventBus.enemy_hit.connect(_on_attack_success)
	EventBus.enemy_missed.connect(_on_attack_fail)
	state_machine.init(self)
	
	starting_position = position

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
	_do_cooldowns(delta)
	state_machine.doProcess(delta)

func _do_cooldowns(delta : float) -> void:
	if dive_ability.current_cooldown > 0.0:
		dive_ability.current_cooldown -= delta
		if dive_ability.current_cooldown < 0.0:
			dive_ability.current_cooldown = 0.0

func _unhandled_input(event: InputEvent) -> void:
	state_machine.do_unhandled_input(event)

func doDiceRoll() -> void:
	if rolling_dice:
		dice_label.text = str(randi_range(1,20))

func doIdleRotation(delta : float) -> void:
	visuals.rotation = lerp_angle(visuals.rotation, 0, rotation_speed * (1/current_time_scale) * delta)
	collision_ball.rotation = visuals.rotation

func doFlyingRotation(delta : float) -> void:
	if linear_velocity.length() > 10:
		var target_angle = linear_velocity.angle()+45
		visuals.rotation = lerp_angle(visuals.rotation, target_angle, rotation_speed * delta)
		collision_ball.rotation = visuals.rotation
	elif reset_rotation_on_ground:
		visuals.rotation = lerp_angle(visuals.rotation, 90, rotation_speed * delta)

func check_landed(delta : float) -> bool:
	if forward_speed < min_speed:
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

var touching_ground_last_frame = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if state_machine.get_current_state() == LAUNCHED and use_burrito_bison_physics:
		forward_speed *= 1.0 - StatsManager.get_air_drag() * state.step
		
		var startingSpeed = forward_speed
		
		if touching_ground:
			var speed_loss = forward_speed*StatsManager.get_ground_drag()
			
			if touching_ground_last_frame:
				speed_loss = speed_loss*state.step
			
			touching_ground_last_frame = true
			
			if forward_speed - speed_loss > 0:
				forward_speed -= speed_loss
				print("starting: "+str(startingSpeed)+" ending: "+str(forward_speed)+" loss: "+str(startingSpeed-forward_speed))
			
			else:
				forward_speed = 0
		
		else:
			touching_ground_last_frame = false
		
		forward_speed = min(forward_speed, max_speed)
		var velocity = state.linear_velocity
		velocity.x = forward_speed
		state.linear_velocity = velocity

func doBounce() -> void:
	var bounce_force = StatsManager.get_bounce_force()
	var forward_force = StatsManager.get_forward_force()
	var isCrit : bool = false
	
	if last_roll >= 20:
		isCrit = true
	
	bounce(bounce_force, forward_force, isCrit)

func bounce(bounce_force : float, forward_force : float, isCrit : bool) -> void:
	if use_burrito_bison_physics:
		var speed_gained = forward_speed*StatsManager.get_speed_boost_percentage()
		if isCrit:
			speed_gained *= 2
		forward_speed += speed_gained
	linear_velocity.y = -abs(linear_velocity.y)*0.9
	
	if isCrit:
		forward_force *= 10
		bounce_force *= 5
	
	linear_velocity.x += forward_force
	var impulse = Vector2.UP * bounce_force# + Vector2.RIGHT * forward_force
	if use_burrito_bison_physics: 
		forward_speed = linear_velocity.x
	apply_impulse(impulse)

func do_launch():
	freeze = false
	print("Launched at ", aim_and_power.power_ratio*100, "% power with value of ", StatsManager.get_launch_power()*aim_and_power.power_ratio)
	launch(aim_and_power.aim_angle, StatsManager.get_launch_power()*aim_and_power.power_ratio)

func launch(angle, power):
	var impulse = Vector2.RIGHT.rotated(deg_to_rad(angle)) * power
	forward_speed = impulse.x
	apply_impulse(impulse)

func start_rolling_dice():
	rolling_dice = true
	
func stop_rolling_dice():
	rolling_dice = false

func change_time_scale(time_scale : float) -> void:
	Engine.time_scale = time_scale
	current_time_scale = time_scale

func doDiceHighlight(duration : float, roll : int, hit : bool) -> void:
	stop_rolling_dice()
	update_dice(str(int(roll)))
	
	var big_size = 48
	var regular_size = 30
	var normal_color = Color.WHITE
	var highlight_color = Color.GREEN
	
	if not hit:
		highlight_color = Color.RED
	
	elif roll == 20:
		highlight_color = Color.GOLDENROD
		big_size = 60
	
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	
	tween.tween_property(dice_label.label_settings, "font_size", big_size, 0.5*current_time_scale).set_trans(Tween.TRANS_SINE)
	tween2.tween_property(dice_label.label_settings, "font_color", highlight_color, 0.5*current_time_scale)
	
	await get_tree().create_timer(duration*current_time_scale).timeout
	
	tween = create_tween()
	tween2 = create_tween() 
	
	tween.tween_property(dice_label.label_settings, "font_size", regular_size, 0.5*current_time_scale).set_trans(Tween.TRANS_SINE)
	tween2.tween_property(dice_label.label_settings, "font_color", normal_color, 0.5*current_time_scale)
	
	await get_tree().create_timer(duration*current_time_scale).timeout
	
	start_rolling_dice()

func update_dice(roll):
	dice_label.text = roll

func _on_attack_success():
	pass

func _on_attack_fail():
	pass

func get_roll() -> int:
	randomize()
	last_roll = randi_range(1, 20)
	return last_roll

func can_dive() -> bool:
	return dive_ability.current_cooldown == 0.0

func stop_movement() -> void:
	linear_velocity = Vector2.ZERO
	stop_rolling_dice()
	if use_burrito_bison_physics:
		forward_speed = 0

# Called from controller to reset the player
func do_reset() -> void:
	freeze = true
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	sleeping = false
	set_deferred("position", starting_position)
	set_deferred("touching_ground", false )
	_reset_ability_cooldowns()
	state_machine.change_state(state_machine.startingState)

func _reset_ability_cooldowns() -> void:
	dive_ability.current_cooldown = 0.0

func die():
	set_deferred("forward_speed", 0)
	set_deferred("linear_velocity.x", 0)
	change_state(dead_state)
