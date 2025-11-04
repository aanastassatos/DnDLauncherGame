extends PlayerState

@export
var landedState : PlayerState

var still_time : float = 0.0

func _ready() -> void:
	if animation_name == "":
		animation_name = "flying"
	
	if state_name == "":
		state_name = parent.LAUNCHED

func enter(params : Dictionary = {}) -> void:
	super()
	EventBus.emit_signal("player_launched")
	#var angle = params.get("angle", 0.0)
	#var power = params.get("power", 0.0)
	#var impulse = Vector2.RIGHT.rotated(deg_to_rad(angle)) * power
	#parent.forward_speed = impulse.x
	#parent.apply_impulse(impulse)

func doProcess(delta: float) -> PlayerState:
	if parent.rolling_dice:
		parent.dice_label.text = str(randi_range(1,20))
	var newState : PlayerState = super(delta)
	
	if parent.linear_velocity.length() < parent.min_speed:
		still_time += delta
		parent.sleeping = false
		if still_time > parent.max_still_time: # been still for a second
			still_time = 0.0
			newState = landedState

	else:
		still_time = 0.0
	
	if parent.linear_velocity.length() > 10:
		var target_angle = parent.linear_velocity.angle()+45
		parent.visuals.rotation = lerp_angle(parent.visuals.rotation, target_angle, parent.rotation_speed * delta)
		parent.collision_ball.rotation = parent.visuals.rotation
	elif parent.reset_rotation_on_ground:
		parent.visuals.rotation = lerp_angle(parent.visuals.rotation, 90, parent.rotation_speed * delta)
	
	return newState
