extends CanvasLayer

signal store_pressed

@onready var distance_label = find_child("DistanceCounter", true, false)
@onready var high_score_label = $ScreenStack/TopOuterMargins/Top/DistanceControl/DistancePanel/InnerMargins/HBoxContainer/CounterBox/HighScoreCounter
@onready var middle_text = $ScreenStack/Middle/InstructionsControl/MiddleTextPanel/MarginContainer/MiddleText
@onready var middle_text_control = $ScreenStack/Middle/InstructionsControl
@onready var money_text = $ScreenStack/TopOuterMargins/Top/MoneyControl/MoneyPanel/Margins/MoneyLabel
@onready var linear_velocity_label = $ScreenStack/TopOuterMargins/Top/VelocityControl/VelocityPanel/Margins/VBoxContainer/VelocityLabel
@onready var velocity_length_label = $ScreenStack/TopOuterMargins/Top/VelocityControl/VelocityPanel/Margins/VBoxContainer/VelocityLengthLabel

@onready var store_button = find_child("StoreButton", true, false)

var high_score : float = 0

func _ready():
	store_button.pressed.connect(_on_store_pressed)
	EventBus.money_changed.connect(_on_money_changed)

func _on_store_pressed():
	emit_signal("store_pressed")

func update_distance(distance: float):
	distance_label.text = str(int(round(distance))) + " m"
	
	if distance > high_score:
		high_score = distance
		high_score_label.text = str(int(round(high_score))) + " m"
		
func update_middle_text(middleTextString : String):
	middle_text.text = middleTextString
	
func hide_middle_text(hideText : bool):
	if hideText:
		middle_text_control.hide()
	
	else:
		middle_text_control.show()

func _on_money_changed(money : int):
	money_text.text = "$"+str(money)

func update_linear_velocity(linear_velocity_vector : Vector2):
	linear_velocity_label.text = "("+str(roundi(linear_velocity_vector.x))+", "+str(roundi(linear_velocity_vector.y))+")"

func update_forward_speed(speed : float):
	velocity_length_label.text = str(round(speed))
