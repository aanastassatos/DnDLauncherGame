extends Node
class_name ShopData

const ITEMS = {
	"health": {
		"id": "health",
		"display_name": "Health Boost",
		"description": "Increases your maximum health by 1 per level.",
		"type": "upgrade",
		"base_cost": 5,
		"cost_multiplier": 1.5
	},
	"launch": {
		"id": "launch",
		"display_name": "Launch Power",
		"description": "Increases the power of your initial launch.",
		"type": "upgrade",
		"base_cost": 5,
		"cost_multiplier": 1.5
	},
	
	"bounce_off": {
		"id": "bounce_off",
		"display_name": "Bounce Force",
		"description": "Improves how high you bounce off enemies.",
		"type": "upgrade",
		"base_cost": 5,
		"cost_multiplier": 1.5
	},
	"launch_off": {
		"id": "launch_off",
		"display_name": "Enemy Launch Boost",
		"description": "Increases horizontal force gained after hitting enemies.",
		"type": "upgrade",
		"base_cost": 5,
		"cost_multiplier": 1.5
	},
	"health_potion": {
		"id": "health_potion",
		"display_name": "Health Potion",
		"description": "A powerful potion that instantly restores your health to 100%. Its price increases as your health level improves.",
		"type": "consumable",
		"base_cost": 5,
		"cost_multiplier": 1.15
	}
}
