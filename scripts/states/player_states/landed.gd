extends PlayerState

func _ready() -> void:
	if animation_name == "":
		animation_name = "Idle"
	
	if state_name == "":
		state_name = parent.LANDED

func enter(params : Dictionary = {}) -> void:
	super()
	parent.linear_velocity = Vector2.ZERO
	parent.stop_rolling_dice()
	if parent.use_burrito_bison_physics:
		parent.forward_speed = 0
	
	EventBus.emit_signal("player_landed")
