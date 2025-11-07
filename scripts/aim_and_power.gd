class_name AimAndPower
extends Node2D

#The Line2D node that for aiming
@onready var aim_line : AimLine = $AimLine

# The Line2D node that visually represents the power
@onready var power_line: PowerLine = $PowerLine

const AIMING : String = "aiming"
const POWERING_UP : String = "powering_up"

var aim_angle : float = 0.0
var power_ratio : float = 0.0

var state : String = ""

func _ready() -> void:
	show_aiming(false)
	show_powering_up(false)

func do_process(delta : float) -> void:
	if state == AIMING:
		aim_line.do_aiming(delta)
	
	if state == POWERING_UP:
		power_line.do_power_up(delta)

func start_aiming() -> void:
	aim_line.start()
	state = AIMING

func stop_aiming() -> void:
	aim_line.stop()
	aim_angle = aim_line.aim_angle
	state = ""

func show_aiming(show_aim_line : bool) -> void:
	if show_aim_line:
		aim_line.show()
	
	else:
		aim_line.hide()

func start_powering_up() -> void:
	power_line.set_aim_angle(aim_angle)
	power_line.start()
	state = POWERING_UP

func stop_powering_up() -> void:
	power_ratio = power_line.stop()
	state = ""

func show_powering_up(show_power_line : bool) -> void:
	if show_power_line:
		power_line.show()
	
	else:
		power_line.hide()
