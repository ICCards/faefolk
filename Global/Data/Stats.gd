extends Node

signal tool_health_change

const MAX_TWIG_WALL = 3
const MAX_WOOD_WALL = 100
const MAX_STONE_WALL = 500
const MAX_METAL_WALL = 1000
const MAX_ARMORED_WALL = 2000

const WOOD_TOOL_HEALTH = 25
const STONE_TOOL_HEALTH = 50
const BRONZE_TOOL_HEALTH = 100
const IRON_TOOL_HEALTH = 200
const GOLD_TOOL_HEALTH = 400

const PUNCH_DAMAGE = 10 #10
const WOOD_TOOL_DAMAGE = 14 #8
const STONE_TOOL_DAMAGE = 16 #7
const BRONZE_TOOL_DAMAGE = 18 #6
const IRON_TOOL_DAMAGE = 20 #5
const GOLD_TOOL_DAMAGE = 25 #4

const WOOD_SWORD_DAMAGE = 25
const STONE_SWORD_DAMAGE = 35
const BRONZE_SWORD_DAMAGE = 50
const IRON_SWORD_DAMAGE = 100
const GOLD_SWORD_DAMAGE = 150

const ARROW_DAMAGE = 100

const MAX_STONE_WATERING_CAN = 25
const MAX_BRONZE_WATERING_CAN = 50
const MAX_GOLD_WATERING_CAN = 100

const BOW_HEALTH = 25


func return_item_drop_quantity(tool_name, object_name):
	match object_name:
		"tree":
			match tool_name:
				"punch":
					return 3
				"wood axe":
					return 6
				"stone axe":
					return 9
				"bronze axe":
					return 12
				"iron axe":
					return 15
				"gold axe":
					return 18
		"stump":
			match tool_name:
				"punch":
					return 2
				"wood axe":
					return 4
				"stone axe":
					return 6
				"bronze axe":
					return 8
				"iron axe":
					return 10
				"gold axe":
					return 12
		"branch":
			match tool_name:
				"punch":
					return 1
				"wood axe":
					return 2
				"stone axe":
					return 3
				"bronze axe":
					return 4
				"iron axe":
					return 5
				"gold axe":
					return 6
		"large ore":
			match tool_name:
				"wood pickaxe":
					return 3
				"stone pickaxe":
					return 6
				"bronze pickaxe":
					return 9
				"iron pickaxe":
					return 12
				"gold pickaxe":
					return 15
		"small ore":
			match tool_name:
				"wood pickaxe":
					return 2
				"stone pickaxe":
					return 4
				"bronze pickaxe":
					return 6
				"iron pickaxe":
					return 8
				"gold pickaxe":
					return 10


func return_max_tool_health(item_name):
	match item_name:
		"wood axe":
			return WOOD_TOOL_HEALTH
		"wood pickaxe":
			return WOOD_TOOL_HEALTH
		"wood sword":
			return WOOD_TOOL_HEALTH
		"wood hoe":
			return WOOD_TOOL_HEALTH
		"stone axe":
			return STONE_TOOL_HEALTH
		"stone pickaxe":
			return STONE_TOOL_HEALTH
		"stone sword":
			return STONE_TOOL_HEALTH
		"stone hoe":
			return STONE_TOOL_HEALTH
		"bronze axe":
			return BRONZE_TOOL_HEALTH
		"bronze pickaxe":
			return BRONZE_TOOL_HEALTH
		"bronze sword":
			return BRONZE_TOOL_HEALTH
		"bronze hoe":
			return BRONZE_TOOL_HEALTH
		"iron axe":
			return IRON_TOOL_HEALTH
		"iron pickaxe":
			return IRON_TOOL_HEALTH
		"iron sword":
			return IRON_TOOL_HEALTH
		"iron hoe":
			return IRON_TOOL_HEALTH
		"gold axe":
			return GOLD_TOOL_HEALTH
		"gold pickaxe":
			return GOLD_TOOL_HEALTH
		"gold sword":
			return GOLD_TOOL_HEALTH
		"gold hoe":
			return GOLD_TOOL_HEALTH
		"stone watering can":
			return MAX_STONE_WATERING_CAN
		"bronze watering can":
			return MAX_BRONZE_WATERING_CAN
		"gold watering can":
			return MAX_GOLD_WATERING_CAN
		"bow":
			return BOW_HEALTH
		_:
			return null

func decrease_tool_health():
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		if PlayerInventory.hotbar[PlayerInventory.active_item_slot][2]:
			PlayerInventory.hotbar[PlayerInventory.active_item_slot][2] -= 1
			emit_signal("tool_health_change")
	

func refill_watering_can(type):
	match type:
		"stone watering can":
			PlayerInventory.hotbar[PlayerInventory.active_item_slot][2] = MAX_STONE_WATERING_CAN
		"bronze watering can":
			PlayerInventory.hotbar[PlayerInventory.active_item_slot][2] = MAX_BRONZE_WATERING_CAN
		"gold watering can":
			PlayerInventory.hotbar[PlayerInventory.active_item_slot][2] = MAX_GOLD_WATERING_CAN
	emit_signal("tool_health_change")
