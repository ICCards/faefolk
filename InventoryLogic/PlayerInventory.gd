extends Node

signal active_item_updated
signal clear_chest
var season = "Spring"
var day_num = 1
var time
var InventorySlots
var HotbarSlots

const SlotClass = preload("res://InventoryLogic/Slot.gd")
const ItemClass = preload("res://InventoryLogic/InventoryItem.gd")
const NUM_INVENTORY_SLOTS = 10
const NUM_HOTBAR_SLOTS = 10

var viewInventoryMode = false
var viewMapMode = false
var interactive_screen_mode = false
var chatMode = false
var chest_id = null
var workbench_id = null
var stove_id = null
var grain_mill_id = null
var furnace_node = null
var is_inside_sleeping_bag_area = false
var direction_of_sleeping_bag = "left"
var active_item_slot = 0

var inventory = {
	2: ["gold ingot", 60, null],
	3: ["rope", 20, null],
	0: ["iron ingot", 60, null],
	6: ["bronze ingot", 60, null],
}

var hotbar = {
}

var chests = {}
var furnaces = {}
var grain_mills = {}

func clear_chest_data(chest_id):
	PlayerInventory.chests.erase(chest_id)

func isSufficientMaterialToCraft(item):
	var ingredients = JsonData.item_data[item]["Ingredients"]
	for i in range(ingredients.size()):
		if returnSufficentCraftingMaterial(ingredients[i][0], ingredients[i][1]):
			continue
		else:
			return false
	return true


func returnSufficentCraftingMaterial(ingredient, amount_needed):
	var total = 0
	for slot in hotbar:
		if hotbar[slot][0] == ingredient:
			total +=  hotbar[slot][1]
	for slot in inventory:
		if inventory[slot][0] == ingredient:
			total += inventory[slot][1]
	if total >= amount_needed:
		return true
	else:
		return false


func craft_item(item):
	if item == "wood door side":
		item = "wood door"
	var ingredients = JsonData.item_data[item]["Ingredients"]
	for i in range(ingredients.size()):
		remove_material(ingredients[i][0], ingredients[i][1])


func remove_material(item, amount):
	var amount_to_remove = amount
	for slot in hotbar.keys():
		if hotbar[slot][0] == item and amount_to_remove != 0:
			if hotbar[slot][1] >= amount_to_remove:
				hotbar[slot][1] = hotbar[slot][1] - amount_to_remove
				amount_to_remove = 0
				update_hotbar_slot_visual(slot, hotbar[slot][0], hotbar[slot][1], hotbar[slot][2])
				return
			else:
				amount_to_remove = amount_to_remove - hotbar[slot][1]
				hotbar[slot][1] = 0 
				update_hotbar_slot_visual(slot, hotbar[slot][0], hotbar[slot][1], hotbar[slot][2])
	if amount_to_remove != 0:
		for slot in inventory.keys():
			if inventory[slot][0] == item and amount_to_remove != 0:
				if inventory[slot][1] >= amount_to_remove:
					inventory[slot][1] = inventory[slot][1] - amount_to_remove
					amount_to_remove = 0
					update_inventory_slot_visual(slot, inventory[slot][0], inventory[slot][1], inventory[slot][2])
					return
				else:
					amount_to_remove = amount_to_remove - inventory[slot][1]
					inventory[slot][1] = 0 
					update_inventory_slot_visual(slot, inventory[slot][0], inventory[slot][1], inventory[slot][2])


# Location of bottom left tile
var player_home = {
	0 : ["Fireplace", Vector2(2,0)],
	1 : ["Crafting_table", Vector2(8,0)],
	2 : ["Shelves", Vector2(16,0)],
	3 : ["Left_chair", Vector2(2,6)],
	4 : ["Middle_chair", Vector2(4, 5)],
	5 : ["Right_chair", Vector2(5, 6)],
	6 : ["Table", Vector2(3, 7)],
	7 : ["Rug", Vector2(10, 7)],
	8 : ["Side_dresser", Vector2(19, 5)],
	9 : ["Bed", Vector2(18, 9)],
	10 : ["Small_dresser", Vector2(10,0)],
	11 : ["Stool", Vector2(4, 8)],
	12 : ["Window 1", Vector2(5, -2)],
	13 : ["Window 2", Vector2(14, -2)],
	14 : ["Painting1", Vector2(9, -2)]
}
var isFireplaceLit = false

func remove_single_object_from_hotbar():
	hotbar[active_item_slot][1] -= 1
	update_hotbar_slot_visual(active_item_slot, hotbar[active_item_slot][0], hotbar[active_item_slot][1] , hotbar[active_item_slot][2])


func can_item_be_added_to_inventory(item_name, item_quantity):
	var slot_indices: Array = hotbar.keys()
	slot_indices.sort()
	# check if it exists in hotbar
	for item in slot_indices:
		if hotbar[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - hotbar[item][1]
			if able_to_add >= item_quantity:
				return true
			else:
				item_quantity = item_quantity - able_to_add
	var inv_slot_indices: Array = inventory.keys()
	inv_slot_indices.sort()
	for item in inv_slot_indices:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				return true
			else:
				item_quantity = item_quantity - able_to_add
	# item doesn't exist, so add it to an empty hotbar slot
	for i in range(NUM_HOTBAR_SLOTS):
		if hotbar.has(i) == false:
			return true
	# item doesn't exist, so add it to an empty inventory slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			return true
	return false



func add_item_to_hotbar(item_name, item_quantity, item_health):
	var slot_indices: Array = hotbar.keys()
	slot_indices.sort()
	for item in slot_indices:
		if hotbar[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - hotbar[item][1]
			if able_to_add >= item_quantity:
				hotbar[item][1] += item_quantity
				update_hotbar_slot_visual(item, hotbar[item][0], hotbar[item][1], hotbar[item][2])
				return
			else:
				hotbar[item][1] += able_to_add
				update_hotbar_slot_visual(item, hotbar[item][0], hotbar[item][1], hotbar[item][2])
				item_quantity = item_quantity - able_to_add

	# item doesn't exist in hotbar yet, so add it to an empty slot
	for i in range(NUM_HOTBAR_SLOTS):
		if hotbar.has(i) == false:
			hotbar[i] = [item_name, item_quantity, item_health]
			update_hotbar_slot_visual(i, item_name, item_quantity, item_health)
			return
	# if hotbar full, add to inventory
	if hotbar.size() == NUM_HOTBAR_SLOTS:
		add_item_to_inventory(item_name, item_quantity, item_health)

func add_item_to_inventory(item_name, item_quantity, item_health):
	var slot_indices: Array = inventory.keys()
	slot_indices.sort()
	for item in slot_indices:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				update_inventory_slot_visual(item, inventory[item][0], inventory[item][1], inventory[item][2])
				return
			else:
				inventory[item][1] += able_to_add
				update_inventory_slot_visual(item, inventory[item][0], inventory[item][1] , inventory[item][2])
				item_quantity = item_quantity - able_to_add

	# item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity, item_health]
			update_inventory_slot_visual(i, inventory[i][0], inventory[i][1], inventory[i][2])
			return
	if hotbar.size() == NUM_HOTBAR_SLOTS:
		### FIX
		print("ITEM CANT BE ADDED TO INVENTORY " + item_name)

func update_hotbar_slot_visual(slot_index, item_name, new_quantity, item_health):
	var slot = HotbarSlots.get_node("Slot" + str(slot_index + 1))
	if slot.item != null:
		if new_quantity == 0:
			remove_item(slot)
			slot.removeFromSlot()
		else:
			slot.item.set_item(item_name, new_quantity, item_health)
	else:
		slot.initialize_item(item_name, new_quantity, item_health)
		
func update_inventory_slot_visual(slot_index, item_name, new_quantity, item_health):
	var slot = InventorySlots.get_node("Slot" + str(slot_index + 1))
	if slot.item != null:
		if new_quantity == 0:
			remove_item(slot)
			slot.removeFromSlot()
		else:
			slot.item.set_item(item_name, new_quantity, item_health)
	else:
		slot.initialize_item(item_name, new_quantity, item_health)
		

func update_chest_slot_visual(slot_index, item_name, new_quantity):
	var slot = get_tree().root.get_node("/root/World/Players/" + str(Server.player_id) + "/" + str(Server.player_id) + "/Camera2D/UserInterface/OpenChest/ChestSlots/Slot" + str(slot_index + 1))
	if slot.item != null:
		if new_quantity == 0:
			remove_item(slot)
			slot.removeFromSlot()
		else:
			slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)

func remove_item(slot: SlotClass, var chest_id = null, var grain_mill_id = null):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)
		SlotClass.SlotType.HOTBAR_INVENTORY:
			hotbar.erase(slot.slot_index)
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		SlotClass.SlotType.CHEST:
			chests[chest_id].erase(slot.slot_index)
		SlotClass.SlotType.GRAIN_MILL:
			grain_mills[grain_mill_id].erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass, var chest_id = null, var grain_mill_id = null):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.HOTBAR_INVENTORY:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.CHEST:
			chests[chest_id][slot.slot_index] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.GRAIN_MILL:
			grain_mills[grain_mill_id][slot.slot_index] = [item.item_name, item.item_quantity, item.item_health]


func add_item_quantity(slot: SlotClass, quantity_to_add: int, var chest_id = null, var grain_mill_id = null):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.HOTBAR_INVENTORY:
			hotbar[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.CHEST:
			chests[chest_id][slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.GRAIN_MILL:
			grain_mills[grain_mill_id][slot.slot_index][1] += quantity_to_add

func decrease_item_quantity(slot: SlotClass, quantity_to_subtract: int, var chest_id = null, var grain_mill_id = null):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] -= quantity_to_subtract
		SlotClass.SlotType.HOTBAR_INVENTORY:
			hotbar[slot.slot_index][1] -= quantity_to_subtract
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] -= quantity_to_subtract
		SlotClass.SlotType.CHEST:
			chests[chest_id][slot.slot_index][1] -= quantity_to_subtract
		SlotClass.SlotType.GRAIN_MILL:
			grain_mills[grain_mill_id][slot.slot_index][1] -= quantity_to_subtract
			


###
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


