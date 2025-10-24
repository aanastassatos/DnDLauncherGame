extends Control

@onready var canvas_layer = $CanvasLayer

# Get stat labels
@onready var health_label = find_child("HealthLevel", true, false)
@onready var launch_label = find_child("LaunchLevel", true, false)
@onready var bounce_label = find_child("BounceLevel", true, false)
@onready var launch_off_label = find_child("LaunchOffLevel", true, false)
@onready var air_drag_label = find_child("AerodynamicsLevel", true, false)
@onready var impact_dampening_level = find_child("ImpactDampeningLevel", true, false)

#Get Money label
@onready var current_money_label = find_child("CurrentMoneyLabel", true, false)

# Get upgrade buttons
@onready var health_upgrade_button = find_child("HealthUpgradeButton", true, false)
@onready var launch_upgrade_button = find_child("LaunchUpgradeButton", true, false)
@onready var bounce_off_enemy_upgrade_button = find_child("BounceOffEnemyUpgradeButton", true, false)
@onready var launch_off_enemy_upgrade_button = find_child("LaunchOffEnemyUpgradeButton", true, false)
@onready var air_drag_upgrade_button = find_child("AirDragUpgradeButton", true, false)
@onready var impact_dampening_upgrade_button = find_child("ImpactDampeningUpgradeButton", true, false)

# Get item buttons
@onready var health_potion_button = find_child("HealthPotionButton", true, false)

# Get Info Panel elements
@onready var info_panel = find_child("InfoMarginContainer", true, false)
@onready var item_name_label = info_panel.find_child("ItemNameLabel", true, false)
@onready var item_description_label = info_panel.find_child("ItemDescriptionLabel", true, false)
@onready var buy_button = info_panel.find_child("BuyButton", true, false)

@onready var back_button = find_child("BackButton", true, false)

# Array of all buttons in shop
var shop_buttons : Array = []

var selected = null

func _ready():
	# Connect each upgrade button
	info_panel.hide()
	EventBus.store_opened.connect(_on_store_open)
	
	#Configure Buttons with correct signals and IDs
	health_upgrade_button.pressed.connect(_on_item_button_pressed.bind(Constants.HEALTH))
	health_upgrade_button.set_meta(Constants.SHOP_DATA_ID, Constants.HEALTH)
	shop_buttons.append(health_upgrade_button)
	
	launch_upgrade_button.pressed.connect(_on_item_button_pressed.bind(Constants.LAUNCH))
	launch_upgrade_button.set_meta(Constants.SHOP_DATA_ID, Constants.LAUNCH)
	shop_buttons.append(launch_upgrade_button)
	
	bounce_off_enemy_upgrade_button.pressed.connect(_on_item_button_pressed.bind(Constants.BOUNCE_OFF))
	bounce_off_enemy_upgrade_button.set_meta(Constants.SHOP_DATA_ID, Constants.BOUNCE_OFF)
	shop_buttons.append(bounce_off_enemy_upgrade_button)
	
	launch_off_enemy_upgrade_button.pressed.connect(_on_item_button_pressed.bind(Constants.LAUNCH_OFF))
	launch_off_enemy_upgrade_button.set_meta(Constants.SHOP_DATA_ID, Constants.LAUNCH_OFF)
	shop_buttons.append(launch_off_enemy_upgrade_button)
	
	air_drag_upgrade_button.pressed.connect(_on_item_button_pressed.bind(Constants.AIR_DRAG))
	air_drag_upgrade_button.set_meta(Constants.SHOP_DATA_ID, Constants.AIR_DRAG)
	shop_buttons.append(air_drag_upgrade_button)
		
	impact_dampening_upgrade_button.pressed.connect(_on_item_button_pressed.bind(Constants.GROUND_DRAG))
	impact_dampening_upgrade_button.set_meta(Constants.SHOP_DATA_ID, Constants.GROUND_DRAG)
	shop_buttons.append(impact_dampening_upgrade_button)
	
	health_potion_button.pressed.connect(_on_item_button_pressed.bind(Constants.HEALTH_POTION))
	health_potion_button.set_meta(Constants.SHOP_DATA_ID, Constants.HEALTH_POTION)
	shop_buttons.append(health_potion_button)
	
	buy_button.pressed.connect(_on_buy_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	
	EventBus.money_changed.connect(set_money)
	EventBus.stats_changed.connect(update_stats)

func _on_store_open():
	update_store()
	show_store()

func update_store():
	#Update Stats
	update_stats()
	set_money(StatsManager.get_money())
	_update_buttons()
	_update_buy_button()

func update_stats():
	set_health(StatsManager.get_current_health(), StatsManager.get_max_health())
	set_launch_level(StatsManager.get_level(Constants.LAUNCH))
	set_bounce_level(StatsManager.get_level(Constants.BOUNCE_OFF))
	set_launch_off_level(StatsManager.get_level(Constants.LAUNCH_OFF))
	set_air_drag_level(StatsManager.get_level(Constants.AIR_DRAG))
	set_ground_drag_level(StatsManager.get_level(Constants.GROUND_DRAG))

func _update_buttons():
	for button in shop_buttons:
		var button_id = button.get_meta(Constants.SHOP_DATA_ID)
		var cost_label = button.find_child("CostLabel")
		cost_label.text = "$"+str(int(get_item_cost(button_id)))

func hide_store():
	canvas_layer.hide()

func show_store():
	canvas_layer.show()

func _on_item_button_pressed(stat_name: String):
	print("upgrade for ",stat_name," pressed")
	selected = ShopData.ITEMS[stat_name]
	
	item_name_label.text = selected[Constants.DISPLAY_NAME]
	item_description_label.text = selected[Constants.DESCRIPTION]
	
	_update_buy_button()
	
	info_panel.show()
	

func _update_buy_button():
	if selected != null:
		var item_cost = get_item_cost(selected[Constants.SHOP_DATA_ID])
		buy_button.text = "Buy For\n$"+str(int(item_cost))
		if is_purchasable(item_cost):
			buy_button.disabled = false
		else:
			buy_button.disabled = true

func get_item_cost(item_id : String):
	if item_id != null:
		var item_info = ShopData.ITEMS[item_id]
		return item_info[Constants.BASE_COST] * pow(item_info[Constants.COST_MULTIPLIER],
													StatsManager.get_level(item_info[Constants.SHOP_DATA_ID]))

func is_purchasable(item_cost : int) -> bool:
	if item_cost <= StatsManager.get_money():
		print(selected[Constants.SHOP_DATA_ID])
		print(selected[Constants.SHOP_DATA_ID] != Constants.HEALTH_POTION)
		if selected[Constants.SHOP_DATA_ID] != Constants.HEALTH_POTION:
			return true
		
		elif StatsManager.get_current_health() < StatsManager.get_max_health():
			return true
	return false

func _on_buy_button_pressed():
	StatsManager.spend_money(get_item_cost(selected[Constants.SHOP_DATA_ID]))
	match selected[Constants.TYPE]:
		Constants.TYPE_UPGRADE:
			StatsManager.upgrade(selected[Constants.SHOP_DATA_ID])
		Constants.TYPE_CONSUMABLE:
			StatsManager.consume(selected[Constants.SHOP_DATA_ID])
			
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

func set_air_drag_level(level):
	air_drag_label.text = str(level)

func set_ground_drag_level(level):
	impact_dampening_level.text = str(level)

func set_money(money):
	current_money_label.text = "$"+str(money)
