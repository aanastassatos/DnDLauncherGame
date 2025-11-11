extends PlayerState

@export var power_up_state : PlayerState

func _ready():
	if animation_name == "":
		animation_name = "Idle"
	
	if state_name == "":
		state_name = parent.AIMING

func enter() -> void:
	super()
	parent.aim_and_power.show_aiming(true)
	parent.aim_and_power.start_aiming()

func exit() -> void:
	parent.aim_and_power.stop_aiming()
	super()

func doProcess(delta: float) -> PlayerState:
	super(delta)
	parent.doIdleRotation(delta)
	parent.aim_and_power.do_process(delta)
	return null

func do_unhandled_input(event : InputEvent) -> PlayerState:
	var new_state : PlayerState = null
	
	if event.is_action_pressed("ui_accept"):
		new_state = power_up_state
	
	return new_state
