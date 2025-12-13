extends AttackResultState

func _ready() -> void:
	if animation_name == "" or state_name == null:
		animation_name = "Sliding"
	
	if state_name == "" or state_name == null:
		state_name = parent.MISS

func doDiceHighlightAsync() -> void:
	await parent.doDiceHighlight(0.6, parent.last_roll, false)
	done_highlight = true
