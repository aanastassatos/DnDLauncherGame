extends CanvasLayer

@onready var distance_label = $ScreenStack/TopOuterMargins/Top/DistanceControl/DistancePanel/InnerMargins/HBoxContainer/CounterBox/DistanceCounter
@onready var high_score_label = $ScreenStack/TopOuterMargins/Top/DistanceControl/DistancePanel/InnerMargins/HBoxContainer/CounterBox/HighScoreCounter
@onready var middle_text = $ScreenStack/Middle/InstructionsControl/MiddleTextPanel/MarginContainer/MiddleText
@onready var middle_text_control = $ScreenStack/Middle/InstructionsControl
@onready var money_text = $ScreenStack/TopOuterMargins/Top/MoneyControl/MoneyPanel/Margins/MoneyLabel
@onready var linear_velocity_label = $ScreenStack/TopOuterMargins/Top/VelocityControl/VelocityPanel/Margins/VBoxContainer/VelocityLabel
@onready var velocity_length_label = $ScreenStack/TopOuterMargins/Top/VelocityControl/VelocityPanel/Margins/VBoxContainer/VelocityLengthLabel

var high_score : float = 0

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

func update_money(money : int):
	money_text.text = "$"+str(money)

func update_linear_velocity(linear_velocity_vector : Vector2):
	linear_velocity_label.text = str(linear_velocity_vector)
	velocity_length_label.text = str(round(linear_velocity_vector.length()))
