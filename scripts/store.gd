extends Control

signal upgrade_requested(stat_name: String)

@onready var canvas_layer = $CanvasLayer

# Get stat labels
@onready var health_label = find_child("HealthLevel", true, false)
@onready var launch_label = find_child("LaunchLevel", true, false)
@onready var bounce_label = find_child("BounceLevel", true, false)
@onready var launch_off_label = find_child("LaunchOffLevel", true, false)

#Get Money label
@onready var current_money_label = find_child("CurrentMoneyLabel", true, false)

# Get upgrade buttons
@onready var health_upgrade_button = find_child("HealthUpgradeButton", true, false)
@onready var launch_upgrade_button = find_child("LaunchUpgradeButton", true, false)
@onready var bounce_off_enemy_upgrade_button = find_child("BounceOffEnemyUpgradeButton", true, false)
@onready var launch_off_enemy_upgrade_button = find_child("LaunchOffEnemyUpgradeButton", true, false)

# Get item buttons
@onready var health_potion_button = find_child("HealthPotionButton", true, false)

# Get Info Panel elements
@onready var info_panel = find_child("InfoMarginContainer", true, false)
@onready var item_name_label = find_child("ItemNameLabel", true, false)
@onready var item_description_label = find_child("ItemDescriptionLabel", true, false)
@onready var buy_button = find_child("BuyButton", true, false)
@onready var back_button = find_child("BackButton", true, false)

var selected = null

func _ready():
	# Connect each upgrade button
	info_panel.hide()
	EventBus.store_opened.connect(_on_store_open)
	health_upgrade_button.pressed.connect(_on_item_button_pressed.bind("health"))
	launch_upgrade_button.pressed.connect(_on_item_button_pressed.bind("launch"))
	bounce_off_enemy_upgrade_button.pressed.connect(_on_item_button_pressed.bind("bounce_off"))
	launch_off_enemy_upgrade_button.pressed.connect(_on_item_button_pressed.bind("launch_off"))
	health_potion_button.pressed.connect(_on_item_button_pressed.bind("health_potion"))
	buy_button.pressed.connect(_on_buy_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	EventBus.money_changed.connect(set_money)

func _on_store_open():
	update_store()
	show_store()

func update_store():
	#Update Stats
	set_health(StatsManager.get_current_health(), StatsManager.get_max_health())
	set_launch_level(StatsManager.get_level("launch"))
	set_bounce_level(StatsManager.get_level("bounce_off"))
	set_launch_off_level(StatsManager.get_level("launch_off"))
	set_money(StatsManager.get_money())
	_update_buy_button()

func hide_store():
	canvas_layer.hide()

func show_store():
	canvas_layer.show()

func _on_item_button_pressed(stat_name: String):
	print("upgrade for ",stat_name," pressed")
	selected = ShopData.ITEMS[stat_name]
	
	item_name_label.text = selected["display_name"]
	item_description_label.text = selected["description"]
	
	_update_buy_button()
	
	info_panel.show()
	

func _update_buy_button():
	var item_cost = get_selected_item_cost()
	buy_button.text = "Buy For\n$"+str(int(item_cost))
	if is_purchasable(item_cost):
		buy_button.disabled = false
	else:
		buy_button.disabled = true

func get_selected_item_cost():
	if selected != null:
		return selected["base_cost"] * pow(selected["cost_multiplier"],StatsManager.get_level(selected["id"]))

func is_purchasable(item_cost : int) -> bool:
	if item_cost <= StatsManager.get_money():
		print(selected["id"])
		print(selected["id"] != "health_potion")
		if selected["id"] != "health_potion":
			return true
		
		elif StatsManager.get_current_health() < StatsManager.get_max_health():
			return true
	return false

func _on_buy_button_pressed():
	StatsManager.spend_money(get_selected_item_cost())
	match selected["type"]:
		"upgrade":
			StatsManager.upgrade(selected["id"])
		"consumable":
			StatsManager.consume(selected["id"])
			
	_update_buy_button()
	update_store()

func _on_back_button_pressed():
	EventBus.emit_signal("store_closed")

func set_health(current, max_health):
	health_label.text = str(current)+"/"+str(max_health)

func set_launch_level(level):
	launch_label.text = str(level)

func set_bounce_level(level):
	bounce_label.text = str(level)

func set_launch_off_level(level):
	launch_off_label.text = str(level)

func set_money(money):
	current_money_label.text = "$"+str(money)
