extends Node

signal active_item_updated

const SlotClass = preload("res://InventoryLogic/Slot.gd")
const ItemClass = preload("res://InventoryLogic/InventoryItem.gd")
const NUM_INVENTORY_SLOTS = 16
const NUM_HOTBAR_SLOTS = 10
var viewInventoryMode = false
var active_item_slot = 0

var inventory = {
	1: ["sword", 1], 
	13: ["green gem", 5],
	4: ["hoe", 1], 
	7: ["hay seeds", 50],
	11: ["potato seeds", 28],
	16: ["bucket", 1]
}

var hotbar = {
	0: ["axe", 1],
	1: ["pickaxe", 1],
	2: ["torch", 24], 
	4: ["hoe", 1], 
	3: ["bucket", 1]
}

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

func place_object():
	hotbar[active_item_slot][1] -= 1
	update_hotbar_slot_visual(active_item_slot, hotbar[active_item_slot][0], hotbar[active_item_slot][1])

	
func add_item_to_hotbar(item_name, item_quantity):
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
			hotbar[i] = [item_name, item_quantity]
			update_hotbar_slot_visual(i, hotbar[i][0], hotbar[i][1])
			return
	# if hotbar full, add to inventory
	if hotbar.size() == NUM_HOTBAR_SLOTS:
		add_item_to_inventory(item_name, item_quantity)

func add_item_to_inventory(item_name, item_quantity):
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
			inventory[i] = [item_name, item_quantity]
			update_inventory_slot_visual(i, inventory[i][0], inventory[i][1])
			return

func update_hotbar_slot_visual(slot_index, item_name, new_quantity):
	var slot = get_tree().root.get_node("/root/PlayerHomeFarm/Player/Camera2D/UserInterface/Hotbar/HotbarSlots/Slot" + str(slot_index + 1))
	if slot.item != null:
		if new_quantity == 0:
			hotbar.erase(slot.slot_index)
			slot.removeFromSlot()
		else:
			slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)

func update_inventory_slot_visual(slot_index, item_name, new_quantity):
	var slot = get_tree().root.get_node("/root/PlayerHomeFarm/Player/Camera2D/UserInterface/Inventory/GridContainer/Slot" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)

func remove_item(slot: SlotClass):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += quantity_to_add


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
	active_item_slot =  slot.slot_index
	emit_signal("active_item_updated")


