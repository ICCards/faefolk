extends Node

signal active_item_updated
signal clear_chest
var season = "Spring"
var day_num = 1
var time

const SlotClass = preload("res://InventoryLogic/Slot.gd")
const ItemClass = preload("res://InventoryLogic/InventoryItem.gd")
const NUM_INVENTORY_SLOTS = 10
const NUM_HOTBAR_SLOTS = 10
var viewInventoryMode = false
var viewMapMode = false
var interactive_screen_mode = false
var chatMode = false
var is_inside_chest_area = false
var is_inside_workbench_area = false
var is_inside_stove_area = false
var is_inside_grain_mill_area = false
var is_inside_sleeping_bag_area = false
var direction_of_sleeping_bag = "left"
var active_item_slot = 0

var inventory = {
	5: ["tomato seeds", 30, null],
	2: ["blueberry seeds", 60, null],
	6: ["corn seeds", 60, null],
	9: ["potato seeds", 30, null],
	3: ["radish seeds", 30, null],
	4: ["wood", 299, null],
	1: ["wood", 499, null],
	7: ["stone", 699, null],
	8: ["stone", 799, null],

}

var hotbar = {
	0: ["potato", 30, null],
	1: ["tomato", 30, null],
	2: ["yellow onion", 30, null],
	3: ["carrot", 30, null],
	4: ["grape", 30, null],
#	2: ["hammer", 1, null],
#	3: ["blueprint", 1, null],
#	5: ["wood sword", 1, 12],
#	6: ["stone watering can", 1, 25],
#	7: ["wood hoe", 1, 7], 
#	8: ["wood axe", 1, 3],
#	1: ["wood axe", 1, 3],
#	9:["wood pickaxe", 1, 5],
}

var chest = {
	0: ["yellow pepper seeds", 30, null],
	1: ["carrot seeds", 30, null],
	2: ["garlic seeds", 30, null],
}

func clear_chest_data():
	emit_signal("clear_chest")


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
	var ingredients = JsonData.crafting_data[item]["ingredients"]
	for i in range(ingredients.size()):
		remove_material(ingredients[i][0], ingredients[i][1])
	add_item_to_hotbar(item, 1, null)


func remove_material(item, amount):
	var amount_to_remove = amount
	for slot in hotbar.keys():
		if hotbar[slot][0] == item and amount_to_remove != 0:
			if hotbar[slot][1] >= amount_to_remove:
				hotbar[slot][1] = hotbar[slot][1] - amount_to_remove
				amount_to_remove = 0
				update_hotbar_slot_visual(slot, hotbar[slot][0], hotbar[slot][1])
			else:
				amount_to_remove = amount_to_remove - hotbar[slot][1]
				hotbar[slot][1] = 0 
				update_hotbar_slot_visual(slot, hotbar[slot][0], hotbar[slot][1])
	if amount_to_remove != 0:
		for slot in inventory.keys():
			if inventory[slot][0] == item and amount_to_remove != 0:
				if inventory[slot][1] >= amount_to_remove:
					inventory[slot][1] = inventory[slot][1] - amount_to_remove
					amount_to_remove = 0
					update_inventory_slot_visual(slot, inventory[slot][0], inventory[slot][1])
				else:
					amount_to_remove = amount_to_remove - inventory[slot][1]
					inventory[slot][1] = 0 
					update_inventory_slot_visual(slot, inventory[slot][0], inventory[slot][1])


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
	update_hotbar_slot_visual(active_item_slot, hotbar[active_item_slot][0], hotbar[active_item_slot][1])


func add_item_to_hotbar(item_name, item_quantity, item_health):
	var slot_indices: Array = hotbar.keys()
	slot_indices.sort()
	for item in slot_indices:
		if hotbar[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - hotbar[item][1]
			if able_to_add >= item_quantity:
				hotbar[item][1] += item_quantity
				update_hotbar_slot_visual(item, hotbar[item][0], hotbar[item][1])
				return
			else:
				hotbar[item][1] += able_to_add
				update_hotbar_slot_visual(item, hotbar[item][0], hotbar[item][1])
				item_quantity = item_quantity - able_to_add

	# item doesn't exist in hotbar yet, so add it to an empty slot
	for i in range(NUM_HOTBAR_SLOTS):
		if hotbar.has(i) == false:
			hotbar[i] = [item_name, item_quantity, item_health]
			update_hotbar_slot_visual(i, hotbar[i][0], hotbar[i][1])
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
				update_inventory_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				update_inventory_slot_visual(item, inventory[item][0], inventory[item][1])
				item_quantity = item_quantity - able_to_add

	# item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity, item_health]
			update_inventory_slot_visual(i, inventory[i][0], inventory[i][1])
			return
	if hotbar.size() == NUM_HOTBAR_SLOTS:
		pass

func update_hotbar_slot_visual(slot_index, item_name, new_quantity):
	var slot = get_tree().root.get_node("/root/World/Players/" + str(Server.player_id) + "/" + str(Server.player_id) + "/Camera2D/UserInterface/Hotbar/HotbarSlots/Slot" + str(slot_index + 1))
	if slot.item != null:
		if new_quantity == 0:
			remove_item(slot)
			slot.removeFromSlot()
		else:
			slot.item.set_item(item_name, new_quantity, null)
	else:
		slot.initialize_item(item_name, new_quantity, null)

func update_inventory_slot_visual(slot_index, item_name, new_quantity):
	var slot = get_tree().root.get_node("/root/World/Players/" + str(Server.player_id) + "/" + str(Server.player_id) + "/Camera2D/UserInterface/Inventory/InventoryMenu/InventorySlots/Slot" + str(slot_index + 1))
	if slot.item != null:
		if new_quantity == 0:
			remove_item(slot)
			slot.removeFromSlot()
		else:
			slot.item.set_item(item_name, new_quantity, null)
	else:
		slot.initialize_item(item_name, new_quantity, null)
		

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

func remove_item(slot: SlotClass):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		SlotClass.SlotType.CHEST:
			chest.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity, item.item_health]
		SlotClass.SlotType.CHEST:
			chest[slot.slot_index] = [item.item_name, item.item_quantity, item.item_health]


func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.CHEST:
			chest[slot.slot_index][1] += quantity_to_add
			
func decrease_item_quantity(slot: SlotClass, quantity_to_subtract: int):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] -= quantity_to_subtract
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] -= quantity_to_subtract
		SlotClass.SlotType.CHEST:
			chest[slot.slot_index][1] -= quantity_to_subtract


func find_open_slot(slot: SlotClass):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			pass
		SlotClass.SlotType.INVENTORY:
			pass
		SlotClass.SlotType.CHEST:
			pass
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


