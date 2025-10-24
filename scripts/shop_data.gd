extends Node
class_name ShopData

const ITEMS = {
	Constants.HEALTH: {
		Constants.SHOP_DATA_ID: Constants.HEALTH,
		Constants.DISPLAY_NAME: "Health Boost",
		Constants.DESCRIPTION: "Increases your maximum health by 1 per level.",
		Constants.TYPE: Constants.TYPE_UPGRADE,
		Constants.BASE_COST: 5,
		Constants.COST_MULTIPLIER: 1.5
	},
	Constants.LAUNCH: {
		Constants.SHOP_DATA_ID: Constants.LAUNCH,
		Constants.DISPLAY_NAME: "Launch Power",
		Constants.DESCRIPTION: "Increases the power of your initial launch.",
		Constants.TYPE: Constants.TYPE_UPGRADE,
		Constants.BASE_COST: 5,
		Constants.COST_MULTIPLIER: 1.5
	},
	
	Constants.BOUNCE_OFF: {
		Constants.SHOP_DATA_ID: Constants.BOUNCE_OFF,
		Constants.DISPLAY_NAME: "Bounce Force",
		Constants.DESCRIPTION: "Improves how high you bounce off enemies.",
		Constants.TYPE: Constants.TYPE_UPGRADE,
		Constants.BASE_COST: 5,
		Constants.COST_MULTIPLIER: 1.5
	},
	Constants.LAUNCH_OFF: {
		Constants.SHOP_DATA_ID: Constants.LAUNCH_OFF,
		Constants.DISPLAY_NAME: "Enemy Launch Speed Boost",
		Constants.DESCRIPTION: "Increases horizontal force gained after hitting enemies.",
		Constants.TYPE: Constants.TYPE_UPGRADE,
		Constants.BASE_COST: 5,
		Constants.COST_MULTIPLIER: 1.5
	},
Constants.AIR_DRAG: {
	Constants.SHOP_DATA_ID: Constants.AIR_DRAG,
	Constants.DISPLAY_NAME: "Improve Aerodynamics",
	Constants.DESCRIPTION: "Reduces air resistance, allowing you to maintain speed longer while flying through the air.",
	Constants.TYPE: Constants.TYPE_UPGRADE,
	Constants.BASE_COST: 8,
	Constants.COST_MULTIPLIER: 1.6
},
Constants.GROUND_DRAG: {
	Constants.SHOP_DATA_ID: Constants.GROUND_DRAG,
	Constants.DISPLAY_NAME: "Impact Dampening",
	Constants.DESCRIPTION: "Lessens the speed lost when you hit the ground, keeping your momentum between bounces.",
	Constants.TYPE: Constants.TYPE_UPGRADE,
	Constants.BASE_COST: 10,
	Constants.COST_MULTIPLIER: 1.6
},
	Constants.HEALTH_POTION: {
		Constants.SHOP_DATA_ID: Constants.HEALTH_POTION,
		Constants.DISPLAY_NAME: "Health Potion",
		Constants.DESCRIPTION: "A powerful potion that instantly restores your health to 100%. Its price increases as your health level improves.",
		Constants.TYPE: Constants.TYPE_CONSUMABLE,
		Constants.BASE_COST: 5,
		Constants.COST_MULTIPLIER: 1.15
	}
}
