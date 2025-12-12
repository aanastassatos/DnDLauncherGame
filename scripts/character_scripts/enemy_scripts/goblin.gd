extends Enemy

@onready var level_label = $Control/Panel/Level

const GOBLIN_ARMOR_CLASS : int = 4
const GOBLIN_DAMAGE : int = 1
const GOBLIN_MONEY_ON_KILL : int = 1

func _ready():
	armor_class = GOBLIN_ARMOR_CLASS
	damage = GOBLIN_DAMAGE
	money_on_kill = GOBLIN_MONEY_ON_KILL
	
	level_label.text = str(armor_class)
