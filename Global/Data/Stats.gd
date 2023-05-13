extends Node

signal tool_health_change_hotbar
signal tool_health_change_combat_hotbar

var skill_descriptions = {
	"sword": {1:{"n":"Sword swing","c":"1 energy","d":"A fast sword swipe."}, 2: {"n":"Sword defense","c":"1 energy","d":"Protects against incoming enemy projectiles."}, 3: {"n":"Enchantment","c":"TBD","d":"TBD"}, 4: {"n":"TBD","c":"TBD","d":"TBD"}},
	#"sword": {1:{"n":"Sword swing","c":"1 energy","d":"A fast sword swipe."}, 2: {"n":"Coming soon...","c":"Coming soon...","d":"Coming soon..."}, 3: {"n":"Coming soon...","c":"Coming soon...","d":"Coming soon..."}, 4: {"n":"Coming soon...","c":"Coming soon...","d":"Coming soon..."}},
	"bow": {1:{"n":"Single-shot","c":"1 energy, 1 arrow","d":"Shoots a single arrow projectile."}, 2: {"n":"Multi-shot","c":"1 energy, 3 arrows","d":"Shoots three arrow projectiles."}, 3: {"n":"Enchantment","c":"1 energy, 1 mana, 1 arrow","d":"Shoots a random poison, ice or fire arrow."}, 4: {"n":"Ricochet shot","c":"1 energy, 2 mana, 2 arrows","d":"Makes arrows bounce between close targets"}},
	"dark": {1:{"n":"Demon warrior","c":"1 mana","d":"..."}, 2: {"n":"Invisibility","c":"2 mana","d":"..."}, 3: {"n":"Demon mage","c":"5 mana","d":"..."}, 4: {"n":"Node3D","c":"10 mana","d":"..."}},
	"electric": {1:{"n":"Electric chain","c":"1 mana","d":"..."}, 2: {"n":"Flash-step","c":"2 mana","d":"..."}, 3: {"n":"Stunned electric chain","c":"5 mana","d":"..."}, 4: {"n":"Lightning strike","c":"10 mana","d":"..."}},
	"earth": {1:{"n":"Earth strike","c":"1 mana","d":"..."}, 2: {"n":"Earth golem","c":"2 mana","d":"..."}, 3: {"n":"Lingering earth strike","c":"5 mana","d":"..."}, 4: {"n":"Earthquake","c":"10 mana","d":"..."}},
	"fire":  {1:{"n":"Fireball","c":"1 mana","d":"Shoots three flaming fireballs"}, 2: {"n":"Strength buff","c":"2 mana","d":"All non-magic weapons do extra damage."}, 3: {"n":"Exploding fireballs","c":"5 mana","d":"Shoots three exploding fireballs."}, 4: {"n":"Flamethrower","c":"10 mana","d":"A powerful stream of destruction."}},
	"wind": {1:{"n":"Tornado","c":"1 mana","d":"A piercing, single shot projectile."}, 2: {"n":"Dash","c":"2 mana","d":"Increased movement speed for short duration."}, 3: {"n":"Lingering tornado","c":"5 mana","d":"Traps and damages enemies within radius."}, 4: {"n":"Whirlwind","c":"10 mana","d":"A powerful spiral attached to the player."}},
	"ice": {1:{"n":"Ice projectile","c":"1 mana","d":"..."}, 2: {"n":"Ice shield","c":"2 mana","d":"..."}, 3: {"n":"Lingering ice projectile","c":"5 mana","d":"..."}, 4: {"n":"Blizzard","c":"10 mana","d":"..."}},
}

const MAX_WOOD_DOOR = 50
const MAX_METAL_DOOR = 10000
const MAX_ARMORED_DOOR = 20000


const MAX_TWIG_BUILDING = 50
const MAX_WOOD_BUILDING = 1000
const MAX_STONE_BUILDING = 5000
const MAX_METAL_BUILDING = 10000
const MAX_ARMORED_BUILDING = 20000

const BOW_HEALTH = 50
const WOOD_TOOL_HEALTH = 25
const STONE_TOOL_HEALTH = 50
const BRONZE_TOOL_HEALTH = 100
const IRON_TOOL_HEALTH = 200
const GOLD_TOOL_HEALTH = 400

const PUNCH_DAMAGE = 10 
const WOOD_TOOL_DAMAGE = 14
const STONE_TOOL_DAMAGE = 16
const BRONZE_TOOL_DAMAGE = 18
const IRON_TOOL_DAMAGE = 25 
const GOLD_TOOL_DAMAGE = 40 

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

const WHIRLWIND_SPELL_DAMAGE = 33
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

const DUCK_HEALTH = 70
const BUNNY_HEALTH = 70
const BEAR_HEALTH = 150
const BOAR_HEALTH = 100
const DEER_HEALTH = 120
const WOLF_HEALTH = 100


const SLIME_HEALTH = 90
const SPIDER_HEALTH = 100
const SKELETON_HEALTH = 100
const BAT_HEALTH = 90
const WIND_BOSS = 1200

func return_max_building_health(tier):
	match tier:
		"twig":
			return MAX_TWIG_BUILDING
		"wood":
			return MAX_WOOD_BUILDING
		"stone":
			return MAX_STONE_BUILDING
		"metal":
			return MAX_METAL_BUILDING
		"armored":
			return MAX_ARMORED_BUILDING

func return_max_door_health(item_name):
	match item_name:
		"wood door":
			return MAX_WOOD_DOOR
		"metal door":
			return MAX_METAL_DOOR
		"armored door":
			return MAX_ARMORED_DOOR

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
		"cactus":
			return randi_range(8,12)


func return_item_drop_quantity(tool_name, object_name):
	match object_name:
		"tree":
			match tool_name:
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
	if PlayerData.normal_hotbar_mode:
		if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
			if PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][2]:
				PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][2] -= 1
				emit_signal("tool_health_change_hotbar")
	else:
		if PlayerData.player_data["combat_hotbar"].has(str(PlayerData.active_item_slot_combat_hotbar)):
			if PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][2]:
				PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][2] -= 1
				emit_signal("tool_health_change_combat_hotbar")
	

func refill_watering_can(type):
	match type:
		"stone watering can":
			if PlayerData.normal_hotbar_mode:
				PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][2] = MAX_STONE_WATERING_CAN
				emit_signal("tool_health_change_hotbar")
			else:
				PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][2] = MAX_STONE_WATERING_CAN
				emit_signal("tool_health_change_combat_hotbar")
		"bronze watering can":
			if PlayerData.normal_hotbar_mode:
				PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][2] = MAX_BRONZE_WATERING_CAN
				emit_signal("tool_health_change_hotbar")
			else:
				PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][2] = MAX_BRONZE_WATERING_CAN
				emit_signal("tool_health_change_combat_hotbar")
		"gold watering can":
			if PlayerData.normal_hotbar_mode:
				PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][2] = MAX_GOLD_WATERING_CAN
				emit_signal("tool_health_change_hotbar")
			else:
				PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][2] = MAX_GOLD_WATERING_CAN
				emit_signal("tool_health_change_combat_hotbar")

