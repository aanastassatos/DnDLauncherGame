extends Button

@export var ability : Ability
@export var signal_name : String = "ability_used"

@onready var cooldown_label : Label = find_child("CooldownLabel", true, false)

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	_update_button_state()

func _process(_delta : float) -> void:
	if ability:
		if ability.current_cooldown > 0:
			_update_button_state()
		else:
			_update_button_state()

func _update_button_state() -> void:
	if ability.current_cooldown > 0:
		disabled = true
		if cooldown_label:
			cooldown_label.text = str(snapped(ability.current_cooldown, 0.1))
			cooldown_label.visible = true
	else:
		disabled = false
		if cooldown_label:
			cooldown_label.visible = false

func _on_button_pressed():
	print("button pressed")
	EventBus.emit_signal(signal_name)
