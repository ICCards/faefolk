extends Node

signal tool_health_change

const MAX_TWIG_WALL = 3
const MAX_WOOD_WALL = 100
const MAX_STONE_WALL = 500
const MAX_METAL_WALL = 1000
const MAX_ARMORED_WALL = 200063

const BOW_HEALTH = 50
const WOOD_TOOL_HEALTH = 25
const STONE_TOOL_HEALTH = 50
const BRONZE_TOOL_HEALTH = 100
const IRON_TOOL_HEALTH = 200
const GOLD_TOOL_HEALTH = 400

const PUNCH_DAMAGE = 10 #10
const WOOD_TOOL_DAMAGE = 14 #8
const STONE_TOOL_DAMAGE = 16 #7
const BRONZE_TOOL_DAMAGE = 18 #6
const IRON_TOOL_DAMAGE = 25 #5
const GOLD_TOOL_DAMAGE = 40 #4

const STUMP_HEALTH = 40
const TREE_HEALTH = 100
const SMALL_ORE_HEALTH = 40
const LARGE_ORE_HEALTH = 100

const WOOD_SWORD_DAMAGE = 20
const STONE_SWORD_DAMAGE = 30
const BRONZE_SWORD_DAMAGE = 40
const IRON_SWORD_DAMAGE = 50
const GOLD_SWORD_DAMAGE = 60

const ARROW_DAMAGE = 25

const DESTRUCTION_POTION_I = 10
const DESTRUCTION_POTION_II = 25
const DESTRUCTION_POTION_III = 50

const FIRE_DEBUFF_DAMAGE = 20

const LIGHTNING_SPELL_DAMAGE = 20
const LIGHTNING_SPELL_DEBUFF_DAMAGE = 30
const LIGHTNING_STRIKE_DAMAGE = 50

const WHIRLWIND_SPELL_DAMAGE = 25
const TORNADO_SPELL_DAMAGE = 20
const ICE_SPELL_DAMAGE = 20
const EARTH_STRIKE_DAMAGE = 60
const FIRE_PROJECTILE_DAMAGE = 20
const FLAMETHROWER_DAMAGE = 20
const EARTHQUAKE_DAMAGE = 15
const LINGERING_TORNADO_DAMAGE = 20

const MAX_STONE_WATERING_CAN = 25
const MAX_BRONZE_WATERING_CAN = 50
const MAX_GOLD_WATERING_CAN = 100

const DUCK_HEALTH = 90
const BUNNY_HEALTH = 90
const BEAR_HEALTH = 160
const BOAR_HEALTH = 140
const DEER_HEALTH = 150


const SLIME_HEALTH = 90
const SPIDER_HEALTH = 100
const SKELETON_HEALTH = 100
const BAT_HEALTH = 90
const WIND_BOSS = 1000


func return_tool_damage(tool_name):
	match tool_name:
		"destruction potion I":
			return DESTRUCTION_POTION_I
		"destruction potion II":
			return DESTRUCTION_POTION_II
		"destruction potion III":
			return DESTRUCTION_POTION_III
		"earthquake":
			return EARTHQUAKE_DAMAGE
		"flamethrower":
			return FLAMETHROWER_DAMAGE
		"fire projectile":
			return FIRE_PROJECTILE_DAMAGE
		"earth strike":
			return EARTH_STRIKE_DAMAGE
		"ice projectile":
			return ICE_SPELL_DAMAGE
		"tornado spell":
			return TORNADO_SPELL_DAMAGE
		"lingering tornado":
			return LINGERING_TORNADO_DAMAGE
		"whirlwind spell":
			return LIGHTNING_SPELL_DAMAGE
		"lightning spell":
			return LIGHTNING_SPELL_DAMAGE
		"lightning spell debuff":
			return LIGHTNING_SPELL_DEBUFF_DAMAGE
		"lightning strike":
			return LIGHTNING_STRIKE_DAMAGE
		"wood sword":
			return WOOD_SWORD_DAMAGE
		"stone sword":
			return STONE_SWORD_DAMAGE
		"bronze sword":
			return BRONZE_SWORD_DAMAGE
		"iron sword":
			return IRON_SWORD_DAMAGE
		"gold sword":
			return GOLD_SWORD_DAMAGE
		"arrow":
			return ARROW_DAMAGE
		"punch":
			return PUNCH_DAMAGE
		"wood axe":
			return WOOD_TOOL_DAMAGE
		"stone axe":
			return STONE_TOOL_DAMAGE
		"bronze axe":
			return BRONZE_TOOL_DAMAGE
		"iron axe":
			return IRON_TOOL_DAMAGE
		"gold axe":
			return GOLD_TOOL_DAMAGE
		"wood pickaxe":
			return WOOD_TOOL_DAMAGE
		"stone pickaxe":
			return STONE_TOOL_DAMAGE
		"bronze pickaxe":
			return BRONZE_TOOL_DAMAGE
		"iron pickaxe":
			return IRON_TOOL_DAMAGE
		"gold pickaxe":
			return GOLD_TOOL_DAMAGE


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
				_:
					return 3
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
				_:
					return 2
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
				_:
					return 1
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
				_:
					return 3
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
				_:
					return 2


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
