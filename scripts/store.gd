extends Control

@onready var health_label = find_child("HealthLevel", true, false)
@onready var launch_label = find_child("LaunchLevel", true, false)
@onready var bounce_label = find_child("BounceLevel", true, false)
@onready var launch_off_label = find_child("LaunchOffLevel", true, false)
@onready var money_mult_label = find_child("MoneyMultLevel", true, false)

func set_health(current, max_health):
	health_label.text = str(current)+"/"+str(max_health)

func set_launch_level(level):
	launch_label.text = str(level)

func set_bounce_level(level):
	bounce_label.text = str(level)

func set_launch_off_level(level):
	launch_off_label.text = str(level)

func set_money_mult_level(level):
	money_mult_label.text = str(level)
