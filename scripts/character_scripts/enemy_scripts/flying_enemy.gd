extends Enemy

@onready var level_label = $Control/Panel/Level

const BAT_ARMOR_CLASS : int = 3
const BAT_DAMAGE : int = 1
const BAT_MONEY_ON_KILL : int = 1

func _ready():
	armor_class = BAT_ARMOR_CLASS
	damage = BAT_DAMAGE
	money_on_kill = BAT_MONEY_ON_KILL
	level_label.text = str(armor_class)
