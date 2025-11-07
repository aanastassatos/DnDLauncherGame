extends PlayerState

@export var launching_state : PlayerState 

func _ready():
	if animation_name == "":
		animation_name = "Idle"
	
	if state_name == "":
		state_name = "Powering_Up"

func enter() -> void:
	super()
	parent.aim_and_power.show_powering_up(true)
	parent.aim_and_power.start_powering_up()

func exit() -> void:
	super()
	parent.aim_and_power.stop_powering_up()
	parent.aim_and_power.show_aiming(false)
	parent.aim_and_power.show_powering_up(false)

func doProcess(delta: float) -> PlayerState:
	parent.doIdleRotation(delta)
	parent.aim_and_power.do_process(delta)
	return null

func do_unhandled_input(event : InputEvent) -> PlayerState:
	var new_state : PlayerState = null
	
	if event.is_action_pressed("ui_accept"):
		new_state = launching_state
	
	return new_state
