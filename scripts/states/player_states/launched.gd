extends PlayerState

@export
var landedState : PlayerState

var still_time : float = 0.0

func _ready() -> void:
	if animation_name == "":
		animation_name = "flying"
	
	if state_name == "":
		state_name = parent.LAUNCHED

func enter() -> void:
	super()
	EventBus.emit_signal("player_launched")

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
	
	parent.doFlyingRotation(delta)
	
	return newState
