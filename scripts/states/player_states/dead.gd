extends PlayerState

func _ready() -> void:
	if animation_name == "":
		animation_name = "Idle"
	
	if state_name == "":
		state_name = parent.DEAD
