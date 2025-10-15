extends RigidBody2D

signal launched
signal landed

@onready var dice_label = $Control/Panel/Dice

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

func _process(delta):
	if flying:
		if linear_velocity.length() < min_speed:
			still_time += delta
			sleeping = false
			if still_time > max_still_time: # been still for a second
				print("landed")
				still_time = 0.0
				linear_velocity = Vector2.ZERO
				flying = false
				stop_rolling_dice()
				emit_signal("landed")
		else:
			still_time = 0.0
			
	if rolling_dice:
		dice_label.text = str(randi_range(1,20))

func bounce(bounce_force, forward_force):
	linear_velocity.y = -abs(linear_velocity.y)
	linear_velocity.x += forward_force
	var impulse = Vector2.UP * bounce_force + Vector2.RIGHT * forward_force
	apply_impulse(impulse)

func launch(angle, power):
	flying = true
	var impulse = Vector2.RIGHT.rotated(deg_to_rad(angle)) * power
	apply_impulse(impulse)
	emit_signal("launched")
	

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
	linear_velocity.x = 0
