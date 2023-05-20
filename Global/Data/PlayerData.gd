extends Node

var spawn_at_last_saved_location: bool = false
var spawn_at_cave_entrance: bool = false
var spawn_at_cave_exit: bool = false
var spawn_at_respawn_location: bool = false

var normal_hotbar_mode = true

signal set_time
signal set_day
signal set_season
signal set_sunrise
signal set_sunset
signal season_changed
signal mana_changed
signal energy_changed
signal health_changed
signal health_depleted
signal tool_health_change
signal active_item_updated
signal key_binding_button_changed

var file_name = "res://JSONData/PlayerData.json"
@onready var SlotClass = load("res://InventoryLogic/Slot.gd")
@onready var ItemClass = load("res://InventoryLogic/InventoryItem.gd")

var viewInventoryMode: bool = false
var viewSaveAndExitMode: bool = false
var viewMapMode: bool = false
var interactive_screen_mode: bool = false
var chatMode: bool = false

var health_maximum = 100
var energy_maximum = 100
var mana_maximum = 100

const NUM_INVENTORY_SLOTS = 20
const NUM_HOTBAR_SLOTS = 10
const NUM_COMBAT_HOTBAR_SLOTS = 4

var InventorySlots
var HotbarSlots
var active_item_slot = 0
var active_item_slot_combat_hotbar = 0


var starting_player_data = {
	"respawn_position": null,
	"health": 100,
	"mana": 100,
	"energy": 100,
	"hotbar": {
		"0": ["bronze pickaxe", 1, 100],
		"1": ["bronze axe", 1, 100],
		"2": ["bronze hoe", 1, 100],
		"3": ["stone fishing rod", 1, null],
		"4": ["blueprint", 1, null],
		#"5": ["hammer", 1, null],
		"5": ["wind staff", 1, null],
		"6": ["stone sword", 1, 50],
		"8": ["raw egg", 10, null],
		"9": ["bow", 1, 50],
		"7": ["stone fishing rod", 1, null],
#		"7": ["grain mill #1", 100, null],
#		"3": ["corn", 100, null],
		#"8": ["bronze watering can", 0, 100],
	#	"3": ["blue flower", 100, null],
#		"4": ["brewing table #3", 10, null],
#		"5": ["brewing table #2", 10, null],
#		"9": ["workbench #2", 10, null],
#		"8": ["furnace", 10, null],
	},
	"inventory": {
			"18": ["wood", 999, null],
			"19": ["arrow", 999, null],
			"17": ["grape", 999, null],
			"5": ["cloth", 500, null],
			"16": ["wood", 999, null],
			"15": ["bronze ingot", 999, null],
			"4": ["iron ingot", 999, null],
			"13": ["wood", 999, null],
#			"12": ["potato seeds", 99, null],
#			"14": ["garlic seeds", 99, null],
#			"15": ["pear seeds", 99, null],
#			"10": ["evergreen seeds", 99, null],
	#		"15": ["wheat flour", 99, null],
			"3": ["bronze ore", 100, null],
	},
	"combat_hotbar": {
	#		"0": ["wind staff", 1, null],
	},
	"skill_experience": {
			"farming": 0,
			"foraging": 0,
			"fishing": 0,
			"mining": 0,
			"sword": 100,
			"bow": 1,
			"dark": 0,
			"electric": 0,
			"earth": 0,
			"fire": 0,
			"wind": 0,
			"ice": 0,
		},
	"collections": {
		"mobs" : {
			"bunny": 0,
			"duck": 0,
			"deer": 0,
			"bear": 0,
			"wolf": 0,
			"boar": 0,
			"slime": 0,
			"spider": 0,
			"bat": 0,
			"skeleton": 0,
		},
		"crops" : {
			"asparagus": 0,
			"blueberry": 0,
			"cabbage": 0,
			"carrot": 0,
			"cauliflower": 0,
			"corn": 0,
			"garlic": 0,
			"grape": 0,
			"green bean": 0,
			"honeydew melon": 0,
			"green pepper": 0,
			"jalapeno": 0,
			"potato": 0,
			"radish": 0,
			"red pepper": 0,
			"strawberry": 0,
			"sugar cane": 0,
			"tomato": 0,
			"wheat": 0,
			"yellow onion": 0,
			"yellow pepper": 0,
			"zucchini": 0,
		},
		"resources" : {
			"wood": 0,
			"stone": 0,
			"coal": 0,
			"rope": 0,
			"bronze ore": 0,
			"iron ore": 0,
			"gold ore": 0,
			"aquamarine": 0,
			"emerald": 0,
			"ruby": 0,
			"sapphire": 0,
		},
		"forage" : {
			"poppy flower": 0,
			"lily of the nile": 0,
			"dandelion": 0,
			"tulip": 0,
			"sunflower": 0,
			"red clam": 0,
			"blue clam": 0,
			"pink clam": 0,
			"starfish": 0,
			"baby starfish": 0,
			"white pearl": 0,
			"blue pearl": 0,
			"pink pearl": 0,
			"dark green grass": 0,
			"green grass": 0,
			"red grass": 0,
			"yellow grass": 0,
			"common mushroom": 0,
			"healing mushroom": 0,
			"purple mushroom": 0,
			"chanterelle": 0,
			"raw egg": 0,
		},
		"fish" : {
			"eel": 0,
			"clownfish": 0,
			"halibut": 0,
			"anchovy": 0,
			"cisco": 0,
			"goldfish": 0,
			"betta": 0,
			"siberian whitefish": 0,
			"red salmon": 0,
			"catfish": 0,
			"koi": 0,
			"purple salmon": 0,
			"lingcod": 0,
			"tilapia": 0,
			"albacore": 0,
			"purple carp": 0,
			"dorado": 0,
			"blowfish": 0,
			"angler": 0,
			"seaweed": 0,
			"octopus": 0,
			"shrimp": 0,
			"crab": 0,
			"nelma": 0
		},
		"food": {
			"wine": 0,
			"asparagus omelette": 0,
			"baked catfish": 0,
			"baked dorado": 0,
			"baked zucchini": 0,
			"blowfish tails": 0,
			"blueberry cake": 0,
			"blueberry pie": 0,
			"bread": 0,
			"calamari with tomatoes": 0,
			"cauliflower soup": 0,
			"cooked filet": 0,
			"cooked green beans": 0,
			"cooked wing": 0,
			"crab cakes": 0,
			"filet mignon": 0,
			"filet soup": 0,
			"filet with garlic mash": 0,
			"filet with tomatoes": 0,
			"grape pastry": 0,
			"green pepper soup": 0,
			"honeydew melon with sugar": 0,
			"mini grape tarts": 0,
			"mushroom soup": 0,
			"pepper and asparagus stir fry": 0,
			"potato soup": 0,
			"potatoes with asparagus": 0,
			"potatoes with green beans": 0,
			"radish soup": 0,
			"red pepper soup": 0,
			"sashimi": 0,
			"sauteed cabbage with garlic": 0,
			"scrambled eggs": 0,
			"seaweed salad": 0,
			"sliced tomatoes and potatoes": 0,
			"smoked jalapeno with eggs": 0,
			"spaghetti": 0,
			"spicy eel": 0,
			"spicy shrimps": 0,
			"strawberry cake": 0,
			"strawberry tart": 0,
			"sugar cane kheer": 0,
			"tomato sandwich": 0,
			"tomato soup": 0,
			"vegetable soup": 0,
			"wings with corn": 0,
			"yellow onion soup": 0,
			"yellow pepper soup": 0,
			"zucchini soup": 0
		}
	},
	"settings":{
		"key_dict": {
			"move right":68,
			"move left":65,
			"move up": 87,
			"move down": 83,
			"open menu": 73,
			"action": 69,
			"rotate": 82,
			"open map": 71,
			"sprint": 4194325,
			"change variety": 86,
			"use tool": 67,
			"switch hotbar": 96,
			"slot 1": 49,
			"slot 2": 50,
			"slot 3": 51,
			"slot 4": 52,
			"slot 5": 53,
			"slot 6": 54,
			"slot 7": 55,
			"slot 8": 56,
			"slot 9": 57,
			"slot 10": 48,
			"cancel attack": 4194312,
			"exit": 4194305
		},
		"volume": {
			"music": 0.0,
			"sound": 50.0,
			"ambient": 0.0,
			"footstep": 50.0
		}
	}
}

var player_data = starting_player_data


func eat(food_name):
	change_energy(JsonData.item_data[food_name]["EnergyHealth"][0])
	change_health(JsonData.item_data[food_name]["EnergyHealth"][1])

func change_mana(amount):
	player_data["mana"] += amount
	if player_data["mana"] < 0:
		player_data["mana"] = 0
	elif player_data["mana"] > mana_maximum:
		player_data["mana"] = mana_maximum
	emit_signal("mana_changed")

func change_health(amount):
	player_data["health"] += amount
	if player_data["health"] <= 0:
		player_data["health"] = 0
		emit_signal("health_depleted")
	elif player_data["health"] >= health_maximum:
		player_data["health"] = health_maximum
	emit_signal("health_changed")

func change_energy(amount):
	player_data["energy"] += amount
	if player_data["energy"] <= 0:
		change_health(-1)
		player_data["energy"] = 0
	elif player_data["energy"] >= energy_maximum:
		player_data["energy"] = energy_maximum
	emit_signal("energy_changed")

func reset_player_stats():
	player_data["energy"] = energy_maximum
	player_data["health"] = health_maximum
	emit_signal("energy_changed")
	emit_signal("health_changed")

### Player Inventory ###
func remove_material(item, amount):
	var amount_to_remove = amount
	for slot in player_data["hotbar"].keys():
		if player_data["hotbar"][slot][0] == item and amount_to_remove != 0:
			if player_data["hotbar"][slot][1] >= amount_to_remove:
				player_data["hotbar"][slot][1] = player_data["hotbar"][slot][1] - amount_to_remove
				update_hotbar_slot_visual(slot, player_data["hotbar"][slot][0], player_data["hotbar"][slot][1], player_data["hotbar"][slot][2])
				return
			else:
				amount_to_remove = amount_to_remove - player_data["hotbar"][slot][1]
				player_data["hotbar"][slot][1] = 0 
				update_hotbar_slot_visual(slot, player_data["hotbar"][slot][0], player_data["hotbar"][slot][1], player_data["hotbar"][slot][2])
	if amount_to_remove != 0:
		for slot in player_data["inventory"].keys():
			if player_data["inventory"][slot][0] == item and amount_to_remove != 0:
				if player_data["inventory"][slot][1] >= amount_to_remove:
					player_data["inventory"][slot][1] = player_data["inventory"][slot][1] - amount_to_remove
					update_inventory_slot_visual(slot, player_data["inventory"][slot][0], player_data["inventory"][slot][1], player_data["inventory"][slot][2])
					return
				else:
					amount_to_remove = amount_to_remove - player_data["inventory"][slot][1]
					player_data["inventory"][slot][1] = 0 
					update_inventory_slot_visual(slot, player_data["inventory"][slot][0], player_data["inventory"][slot][1], player_data["inventory"][slot][2])



func pick_up_item(item_name, item_quantity, item_health):
	for slot in NUM_HOTBAR_SLOTS: # Add to existing hotbar slot
		if player_data["hotbar"].has(str(slot)):
			if player_data["hotbar"][str(slot)][0] == item_name:
				var stack_size = int(JsonData.item_data[item_name]["StackSize"])
				var able_to_add = stack_size - player_data["hotbar"][str(slot)][1]
				if able_to_add >= item_quantity:
					player_data["hotbar"][str(slot)][1] += item_quantity
					update_hotbar_slot_visual(str(slot), player_data["hotbar"][str(slot)][0], player_data["hotbar"][str(slot)][1], player_data["hotbar"][str(slot)][2])
					return
				else:
					player_data["hotbar"][str(slot)][1] += able_to_add
					update_hotbar_slot_visual(str(slot), player_data["hotbar"][str(slot)][0], player_data["hotbar"][str(slot)][1], player_data["hotbar"][str(slot)][2])
					item_quantity = item_quantity - able_to_add
	for slot in NUM_INVENTORY_SLOTS: # Add to existing inventory slot
		if player_data["inventory"].has(str(slot)):
			if player_data["inventory"][str(slot)][0] == item_name:
				var stack_size = int(JsonData.item_data[item_name]["StackSize"])
				var able_to_add = stack_size - player_data["inventory"][str(slot)][1]
				if able_to_add >= item_quantity:
					player_data["inventory"][str(slot)][1] += item_quantity
					update_inventory_slot_visual(str(slot), player_data["inventory"][str(slot)][0], player_data["inventory"][str(slot)][1], player_data["inventory"][str(slot)][2])
					return
				else:
					player_data["inventory"][str(slot)][1] += able_to_add
					update_inventory_slot_visual(str(slot), player_data["inventory"][str(slot)][0], player_data["inventory"][str(slot)][1], player_data["inventory"][str(slot)][2])
					item_quantity = item_quantity - able_to_add
	for i in range(NUM_HOTBAR_SLOTS): # Add to empty hotbar slot 
		if player_data["hotbar"].has(str(i)) == false:
			player_data["hotbar"][str(i)] = [item_name, item_quantity, item_health]
			update_hotbar_slot_visual(i, item_name, item_quantity, item_health)
			Server.player_node.set_held_object()
			return
	for i in range(NUM_INVENTORY_SLOTS): # Add to empty inventory slot 
		if player_data["inventory"].has(str(i)) == false:
			player_data["inventory"][str(i)] = [item_name, item_quantity, item_health]
			update_inventory_slot_visual(i, item_name, item_quantity, item_health)
			return
	# All slots are filled so drop it
	InstancedScenes.initiateInventoryItemDrop([item_name, item_quantity, item_health], Server.player_node.position)
	

func update_inventory_slot_visual(slot_index, item_name, new_quantity, item_health):
	if not InventorySlots:
		InventorySlots = Server.player_node.user_interface.get_node("Menu/Pages/inventory/InventorySlots")
	var slot = InventorySlots.get_node("Slot" + str(int(slot_index) + 1))
	if slot.item != null:
		if new_quantity == 0:
			remove_item(slot)
			slot.removeFromSlot()
		else:
			slot.item.set_item(item_name, new_quantity, item_health)
	else:
		slot.initialize_item(item_name, new_quantity, item_health)

func update_hotbar_slot_visual(slot_index, item_name, new_quantity, item_health):
	if not HotbarSlots:
		HotbarSlots = Server.player_node.user_interface.get_node("Hotbar/HotbarSlots")
	var slot = HotbarSlots.get_node("Slot" + str(int(slot_index) + 1))
	if slot.item != null:
		if new_quantity == 0:
			remove_item(slot)
			slot.removeFromSlot()
		else:
			slot.item.set_item(item_name, new_quantity, item_health)
	else:
		slot.initialize_item(item_name, new_quantity, item_health)
		
func update_combat_hotbar_slot_visual(slot_index, item_name, new_quantity, item_health):
	var slot = Server.player_node.user_interface.get_node("CombatHotbar/ItemSlots/Slot" + str(int(slot_index) + 1))
	if slot.item != null:
		if new_quantity == 0:
			remove_item(slot)
			slot.removeFromSlot()
		else:
			slot.item.set_item(item_name, new_quantity, item_health)
	else:
		slot.initialize_item(item_name, new_quantity, item_health)


func add_item_to_empty_slot(item, slot, id = null):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			player_data["hotbar"][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.HOTBAR_INVENTORY:
			player_data["hotbar"][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.COMBAT_HOTBAR:
			player_data["combat_hotbar"][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.COMBAT_HOTBAR_INVENTORY:
			player_data["combat_hotbar"][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.INVENTORY:
			player_data["inventory"][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
		_:
			Server.world.server_data["ui_slots"][id][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
#		SlotClass.SlotType.CHEST:
#			player_data["chests"][id][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
#		SlotClass.SlotType.GRAIN_MILL:
#			player_data["grain_mills"][id][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
#		SlotClass.SlotType.STOVE:
#			player_data["stoves"][id][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
#		SlotClass.SlotType.FURNACE:
#			player_data["furnaces"][id][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
#		SlotClass.SlotType.CAMPFIRE:
#			player_data["campfires"][id][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
#		SlotClass.SlotType.BARREL:
#			player_data["barrels"][id][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]


func remove_item(slot, id = null):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			player_data["hotbar"].erase(str(slot.slot_index))
		SlotClass.SlotType.HOTBAR_INVENTORY:
			player_data["hotbar"].erase(str(slot.slot_index))
		SlotClass.SlotType.COMBAT_HOTBAR:
			player_data["combat_hotbar"].erase(str(slot.slot_index))
		SlotClass.SlotType.COMBAT_HOTBAR_INVENTORY:
			player_data["combat_hotbar"].erase(str(slot.slot_index))
		SlotClass.SlotType.INVENTORY:
			player_data["inventory"].erase(str(slot.slot_index))
		_:
			Server.world.server_data["ui_slots"][id].erase(str(slot.slot_index))
#		SlotClass.SlotType.CHEST:
#			player_data["chests"][id].erase(str(slot.slot_index))
#		SlotClass.SlotType.GRAIN_MILL:
#			player_data["grain_mills"][id].erase(str(slot.slot_index))
#		SlotClass.SlotType.STOVE:
#			player_data["stoves"][id].erase(str(slot.slot_index))
#		SlotClass.SlotType.FURNACE:
#			player_data["furnaces"][id].erase(str(slot.slot_index))
#		SlotClass.SlotType.CAMPFIRE:
#			player_data["campfires"][id].erase(str(slot.slot_index))
#		SlotClass.SlotType.BARREL:
#			player_data["barrels"][id].erase(str(slot.slot_index))

func add_item_quantity(slot, quantity_to_add: int, id = null):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			player_data["hotbar"][str(slot.slot_index)][1] += quantity_to_add
		SlotClass.SlotType.HOTBAR_INVENTORY:
			player_data["hotbar"][str(slot.slot_index)][1] += quantity_to_add
		SlotClass.SlotType.COMBAT_HOTBAR:
			player_data["combat_hotbar"][str(slot.slot_index)][1] += quantity_to_add
		SlotClass.SlotType.COMBAT_HOTBAR_INVENTORY:
			player_data["combat_hotbar"][str(slot.slot_index)][1] += quantity_to_add
		SlotClass.SlotType.INVENTORY:
			player_data["inventory"][str(slot.slot_index)][1] += quantity_to_add
		_:
			player_data["chests"][id][str(slot.slot_index)][1] += quantity_to_add
#		SlotClass.SlotType.CHEST:
#			player_data["chests"][id][str(slot.slot_index)][1] += quantity_to_add
#		SlotClass.SlotType.GRAIN_MILL:
#			player_data["grain_mills"][id][str(slot.slot_index)][1] += quantity_to_add
#		SlotClass.SlotType.STOVE:
#			player_data["stoves"][id][str(slot.slot_index)][1] += quantity_to_add
#		SlotClass.SlotType.FURNACE:
#			player_data["furnaces"][id][str(slot.slot_index)][1] += quantity_to_add
#		SlotClass.SlotType.CAMPFIRE:
#			player_data["campfires"][id][str(slot.slot_index)][1] += quantity_to_add
#		SlotClass.SlotType.BARREL:
#			player_data["barrels"][id][str(slot.slot_index)][1] += quantity_to_add
			
func decrease_item_quantity(slot, quantity_to_subtract: int, id = null):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			player_data["hotbar"][str(slot.slot_index)][1] -= quantity_to_subtract
		SlotClass.SlotType.HOTBAR_INVENTORY:
			player_data["hotbar"][str(slot.slot_index)][1] -= quantity_to_subtract
		SlotClass.SlotType.COMBAT_HOTBAR:
			player_data["combat_hotbar"][str(slot.slot_index)][1] -= quantity_to_subtract
		SlotClass.SlotType.COMBAT_HOTBAR_INVENTORY:
			player_data["combat_hotbar"][str(slot.slot_index)][1] -= quantity_to_subtract
#		SlotClass.SlotType.INVENTORY:
#			player_data["chests"][id][str(slot.slot_index)][1] += quantity_to_add
#		_:
#			player_data["chests"][id][str(slot.slot_index)][1] += quantity_to_add
#		SlotClass.SlotType.CHEST:
#			player_data["chests"][id][str(slot.slot_index)][1] -= quantity_to_subtract
#		SlotClass.SlotType.GRAIN_MILL:
#			player_data["grain_mills"][id][str(slot.slot_index)][1] -= quantity_to_subtract
#		SlotClass.SlotType.STOVE:
#			player_data["stoves"][id][str(slot.slot_index)][1] -= quantity_to_subtract
#		SlotClass.SlotType.FURNACE:
#			player_data["furnaces"][id][str(slot.slot_index)][1] -= quantity_to_subtract
#		SlotClass.SlotType.CAMPFIRE:
#			player_data["campfires"][id][str(slot.slot_index)][1] -= quantity_to_subtract
#		SlotClass.SlotType.BARREL:
#			player_data["barrels"][id][str(slot.slot_index)][1] -= quantity_to_subtract

func return_resource_total(item_name):
	var total = 0
	var hotbar = player_data["hotbar"]
	var inventory = player_data["inventory"]
	for slot in hotbar:
		if hotbar[str(slot)][0] == item_name:
			total +=  hotbar[str(slot)][1]
	for slot in inventory:
		if inventory[str(slot)][0] == item_name:
			total += inventory[str(slot)][1]
	return total

func returnSufficentCraftingMaterial(ingredient, amount_needed):
	var total = return_resource_total(ingredient)
	if total >= amount_needed:
		return true
	return false

func isSufficientMaterialToCraft(item):
	var ingredients = JsonData.item_data[item]["Ingredients"]
	for i in range(ingredients.size()):
		if returnSufficentCraftingMaterial(ingredients[i][0], ingredients[i][1]):
			continue
		else:
			return false
	return true

func craft_item(item):
	var ingredients = JsonData.item_data[item]["Ingredients"]
	for i in range(ingredients.size()):
		remove_material(ingredients[i][0], ingredients[i][1])

func remove_single_object_from_hotbar():
	if PlayerData.normal_hotbar_mode:
		player_data["hotbar"][str(active_item_slot)][1] -= 1
		update_hotbar_slot_visual(active_item_slot, player_data["hotbar"][str(active_item_slot)][0], player_data["hotbar"][str(active_item_slot)][1] , player_data["hotbar"][str(active_item_slot)][2])
	else:
		player_data["combat_hotbar"][str(active_item_slot_combat_hotbar)][1] -= 1
		update_combat_hotbar_slot_visual(active_item_slot_combat_hotbar, player_data["combat_hotbar"][str(active_item_slot_combat_hotbar)][0], player_data["combat_hotbar"][str(active_item_slot_combat_hotbar)][1] , player_data["combat_hotbar"][str(active_item_slot_combat_hotbar)][2])

### Change active hotbar functions

func slot_selected(slot_index) -> void:
	if PlayerData.normal_hotbar_mode:
		active_item_slot = slot_index
		emit_signal("active_item_updated")
	else:
		if slot_index > 3 and slot_index < 8:
			active_item_slot_combat_hotbar = slot_index - 4
			emit_signal("active_item_updated")

func active_item_scroll_up() -> void:
	if PlayerData.normal_hotbar_mode:
		active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	else:
		active_item_slot_combat_hotbar = (active_item_slot_combat_hotbar + 1) % NUM_COMBAT_HOTBAR_SLOTS
	emit_signal("active_item_updated")

func active_item_scroll_down() -> void:
	if PlayerData.normal_hotbar_mode:
		if active_item_slot == 0:
			active_item_slot = NUM_HOTBAR_SLOTS - 1
		else:
			active_item_slot -= 1
	else:
		if active_item_slot_combat_hotbar == 0:
			active_item_slot_combat_hotbar = NUM_COMBAT_HOTBAR_SLOTS - 1
		else:
			active_item_slot_combat_hotbar -= 1
	emit_signal("active_item_updated")

func hotbar_slot_selected(slot) -> void:
	if PlayerData.normal_hotbar_mode:
		active_item_slot = slot.slot_index
	else:
		active_item_slot_combat_hotbar = slot.slot_index
	emit_signal("active_item_updated")

