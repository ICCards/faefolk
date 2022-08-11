extends Node

signal tool_health_change

const MAX_TWIG_WALL = 10
const MAX_WOOD_WALL = 250
const MAX_STONE_WALL = 500
const MAX_METAL_WALL = 1000
const MAX_ARMORED_WALL = 2000

const WOOD_TOOL_HEALTH = 25
const STONE_TOOL_HEALTH = 50
const BRONZE_TOOL_HEALTH = 100
const IRON_TOOL_HEALTH = 200
const GOLD_TOOL_HEALTH = 400

const MAX_STONE_WATERING_CAN = 25
const MAX_BRONZE_WATERING_CAN = 50
const MAX_GOLD_WATERING_CAN = 100


func decrease_tool_health():
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
