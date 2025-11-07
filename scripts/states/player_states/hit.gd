extends AttackState

func _ready() -> void:
	if animation_name == "" or state_name == null:
		animation_name = "kick"
	
	if state_name == "" or state_name == null:
		state_name = parent.ATTACK

func enter() -> void:
	parent.doBounce()
	super()

func doProcess(delta: float) -> PlayerState:
	parent.doIdleRotation(delta)
	return super(delta)

func doDiceHighlightAsync() -> void:
	await parent.doDiceHighlight(0.6, parent.last_roll, true)
	done_highlight = true
