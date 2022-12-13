extends Node

signal mana_changed
signal energy_changed
signal health_changed
signal health_depleted
signal tool_health_change
signal active_item_updated

var file_name = "res://JSONData/PlayerData.json"
onready var SlotClass = load("res://InventoryLogic/Slot.gd")
onready var ItemClass = load("res://InventoryLogic/InventoryItem.gd")

var viewInventoryMode: bool = false
var viewMapMode: bool = false
var interactive_screen_mode: bool = false

var health_maximum = 100
var energy_maximum = 100
var mana_maximum = 100

const NUM_INVENTORY_SLOTS = 10
const NUM_HOTBAR_SLOTS = 10

var InventorySlots
var HotbarSlots
var active_item_slot = 0

var player_data = {}
var starting_player_data = {
	"day_week": "Monday",
	"day_number": 1,
	"time_minutes": 0,
	"time_hours": 6,
	"health": 100,
	"mana": 100,
	"energy": 100,
	"hotbar": {
		"0": ["wind staff", 1, null],
		"2": ["bow", 1, 50],
		"1": ["stone sword", 1, null],
		"7": ["arrow", 500, null]
	},
	"inventory": {
			"0": ["electric staff", 1, null],
			"1": ["dark magic staff", 1, null],
			"2": ["fire staff", 1, null],
			"4": ["ice staff", 1, null],
			"3": ["earth staff", 1, null],
			"8": ["wood", 500, null],
			"9": ["stone", 500, null],
			"7": ["iron ingot", 150, null],
	},
	"chests": {
		"Cave 1-1": {
			"4": ["wheat seeds", 25, null],
			"9": ["health potion I", 2, null],
			"14": ["destruction potion I", 5, null]
		},
		"Cave 1-2": {
			"2": ["bread", 4, null],
			"6": ["regeneration potion II", 3, null],
			"12": ["bronze ore", 8, null]
		}
	},
	"furnaces": {},
	"grain_mills": {},
	"stoves": {},
}

func _ready():
	load_player_data()

func save_player_data():
	var file = File.new()
	file.open(file_name,File.WRITE)
	file.store_string(to_json(player_data))
	file.close()
	print("saved player data")
	
func load_player_data():
	var file = File.new()
	if(file.file_exists(file_name)):
		file.open(file_name,File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if(typeof(data) == TYPE_DICTIONARY):
			print("LOADED PLAYER DATA")
			player_data = data
		else:
			printerr("corrupted player data!")
	else:
		#No File, so lets save the default player data now
		player_data = starting_player_data
		save_player_data()


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
		player_data["energy"] = 0
	elif player_data["energy"] >= energy_maximum:
		player_data["energy"] = energy_maximum
	emit_signal("energy_changed")

func respawn_player():
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

func add_item_to_hotbar(item_name, item_quantity, item_health):
	var slot_indices: Array = player_data["hotbar"].keys()
	slot_indices.sort()
	for item in slot_indices:
		if player_data["hotbar"][item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - player_data["hotbar"][item][1]
			if able_to_add >= item_quantity:
				player_data["hotbar"][item][1] += item_quantity
				update_hotbar_slot_visual(item, player_data["hotbar"][item][0], player_data["hotbar"][item][1], player_data["hotbar"][item][2])
				return
			else:
				player_data["hotbar"][item][1] += able_to_add
				update_hotbar_slot_visual(item, player_data["hotbar"][item][0], player_data["hotbar"][item][1], player_data["hotbar"][item][2])
				item_quantity = item_quantity - able_to_add
	# item doesn't exist in hotbar yet, so add it to an empty slot
	for i in range(NUM_HOTBAR_SLOTS):
		if player_data["hotbar"].has(str(i)) == false:
			player_data["hotbar"][str(i)] = [item_name, item_quantity, item_health]
			update_hotbar_slot_visual(i, item_name, item_quantity, item_health)
			return
	# if hotbar full, add to inventory
	add_item_to_inventory(item_name, item_quantity, item_health)

func add_item_to_inventory(item_name, item_quantity, item_health):
	var slot_indices: Array = player_data["inventory"].keys()
	slot_indices.sort()
	for item in slot_indices:
		if player_data["inventory"][item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - player_data["inventory"][item][1]
			if able_to_add >= item_quantity:
				player_data["inventory"][item][1] += item_quantity
				update_inventory_slot_visual(item, player_data["inventory"][item][0], player_data["inventory"][item][1], player_data["inventory"][item][2])
				return
			else:
				player_data["inventory"][item][1] += able_to_add
				update_inventory_slot_visual(item, player_data["inventory"][item][0], player_data["inventory"][item][1] , player_data["inventory"][item][2])
				item_quantity = item_quantity - able_to_add
	# item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if player_data["inventory"].has(i) == false:
			player_data["inventory"][i] = [item_name, item_quantity, item_health]
			update_inventory_slot_visual(i, player_data["inventory"][i][0], player_data["inventory"][i][1], player_data["inventory"][i][2])
			return
	InstancedScenes.initiateInventoryItemDrop([item_name, item_quantity, item_health], Server.player_node.position)

func update_inventory_slot_visual(slot_index, item_name, new_quantity, item_health):
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
	var slot = HotbarSlots.get_node("Slot" + str(int(slot_index) + 1))
	if slot.item != null:
		if new_quantity == 0:
			remove_item(slot)
			slot.removeFromSlot()
		else:
			slot.item.set_item(item_name, new_quantity, item_health)
	else:
		slot.initialize_item(item_name, new_quantity, item_health)


func add_item_to_empty_slot(item, slot, var id = null):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			player_data["hotbar"][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.HOTBAR_INVENTORY:
			player_data["hotbar"][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.INVENTORY:
			player_data["inventory"][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.CHEST:
			player_data["chests"][id][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.GRAIN_MILL:
			player_data["grain_mills"][id][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.STOVE:
			player_data["stoves"][id][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.FURNACE:
			player_data["furnaces"][id][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.TOOL_CABINET:
			player_data["tool_cabinets"][id][str(slot.slot_index)] = [item.item_name, item.item_quantity, item.item_health]


func remove_item(slot, var id = null):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			player_data["hotbar"].erase(str(slot.slot_index))
		SlotClass.SlotType.HOTBAR_INVENTORY:
			player_data["hotbar"].erase(str(slot.slot_index))
		SlotClass.SlotType.INVENTORY:
			player_data["inventory"].erase(str(slot.slot_index))
		SlotClass.SlotType.CHEST:
			player_data["chests"][id].erase(str(slot.slot_index))
		SlotClass.SlotType.GRAIN_MILL:
			player_data["grain_mills"][id].erase(str(slot.slot_index))
		SlotClass.SlotType.STOVE:
			player_data["stoves"][id].erase(str(slot.slot_index))
		SlotClass.SlotType.FURNACE:
			player_data["furnaces"][id].erase(str(slot.slot_index))
		SlotClass.SlotType.TOOL_CABINET:
			player_data["tool_cabinets"][id].erase(str(slot.slot_index))

func add_item_quantity(slot, quantity_to_add: int, var id = null):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			player_data["hotbar"][str(slot.slot_index)][1] += quantity_to_add
		SlotClass.SlotType.HOTBAR_INVENTORY:
			player_data["hotbar"][str(slot.slot_index)][1] += quantity_to_add
		SlotClass.SlotType.INVENTORY:
			player_data["inventory"][str(slot.slot_index)][1] += quantity_to_add
		SlotClass.SlotType.CHEST:
			player_data["chests"][id][str(slot.slot_index)][1] += quantity_to_add
		SlotClass.SlotType.GRAIN_MILL:
			player_data["grain_mills"][id][str(slot.slot_index)][1] += quantity_to_add
		SlotClass.SlotType.STOVE:
			player_data["stoves"][id][str(slot.slot_index)][1] += quantity_to_add
		SlotClass.SlotType.FURNACE:
			player_data["furnaces"][id][str(slot.slot_index)][1] += quantity_to_add
		SlotClass.SlotType.TOOL_CABINET:
			player_data["tool_cabintes"][id][str(slot.slot_index)][1] += quantity_to_add
			
func decrease_item_quantity(slot, quantity_to_subtract: int, var id = null):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			player_data["hotbar"][str(slot.slot_index)][1] -= quantity_to_subtract
		SlotClass.SlotType.HOTBAR_INVENTORY:
			player_data["hotbar"][str(slot.slot_index)][1] -= quantity_to_subtract
		SlotClass.SlotType.INVENTORY:
			player_data["inventory"][str(slot.slot_index)][1] -= quantity_to_subtract
		SlotClass.SlotType.CHEST:
			player_data["chests"][id][str(slot.slot_index)][1] -= quantity_to_subtract
		SlotClass.SlotType.GRAIN_MILL:
			player_data["grain_mills"][id][str(slot.slot_index)][1] -= quantity_to_subtract
		SlotClass.SlotType.STOVE:
			player_data["stoves"][id][str(slot.slot_index)][1] -= quantity_to_subtract
		SlotClass.SlotType.FURNACE:
			player_data["furnaces"][id][str(slot.slot_index)][1] -= quantity_to_subtract
		SlotClass.SlotType.TOOL_CABINET:
			player_data["tool_cabintes"][id][str(slot.slot_index)][1] -= quantity_to_subtract

func return_resource_total(item_name):
	var total = 0
	var hotbar = PlayerData.player_data["hotbar"]
	var inventory = PlayerData.player_data["inventory"]
	for slot in hotbar:
		if hotbar[slot][0] == item_name:
			total +=  hotbar[slot][1]
	for slot in inventory:
		if inventory[slot][0] == item_name:
			total += inventory[slot][1]
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
	player_data["hotbar"][str(active_item_slot)][1] -= 1
	update_hotbar_slot_visual(active_item_slot, player_data["hotbar"][str(active_item_slot)][0], player_data["hotbar"][str(active_item_slot)][1] , player_data["hotbar"][str(active_item_slot)][2])


### Change active hotbar functions
func active_item_scroll_up() -> void:
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	emit_signal("active_item_updated")

func active_item_scroll_down() -> void:
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")

func hotbar_slot_selected(slot) -> void:
	active_item_slot = slot.slot_index
	emit_signal("active_item_updated")

