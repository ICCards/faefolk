extends Node2D


onready var inventory_slots = $InventorySlots
onready var chest_slots = $ChestSlots
const SlotClass = preload("res://InventoryLogic/Slot.gd")

func _ready():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slotType = SlotClass.SlotType.INVENTORY
	initialize_inventory()
	
	
	initialize_chest_data()
	var slots_in_chest = chest_slots.get_children()
	for i in range(slots_in_chest.size()):
		slots_in_chest[i].connect("gui_input", self, "slot_gui_input", [slots_in_chest[i]])
		slots_in_chest[i].slot_index = i
		slots_in_chest[i].slotType = SlotClass.SlotType.CHEST
	PlayerInventory.connect("clear_chest", self, "clear_chest_data")
	
	
func clear_chest_data():
	var slots_in_chest = chest_slots.get_children()
	for i in range(slots_in_chest.size()):
		if PlayerInventory.chest.has(i):
			PlayerInventory.remove_item(slots_in_chest[i])
			slots_in_chest[i].removeFromSlot()
	
func initialize_chest_data():
	var slots_in_chest = chest_slots.get_children()
	for i in range(slots_in_chest.size()):
		if PlayerInventory.chest.has(i):
			slots_in_chest[i].initialize_item(PlayerInventory.chest[i][0], PlayerInventory.chest[i][1])


func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if slots[i].item != null:
			slots[i].removeFromSlot()
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])


func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if find_parent("UserInterface").holding_item != null:
				if !slot.item:
					left_click_empty_slot(slot)
				else:
					if find_parent("UserInterface").holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)
				
func left_click_empty_slot(slot: SlotClass):
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = null
	
func left_click_different_item(event: InputEvent, slot: SlotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= find_parent("UserInterface").holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity)
		slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)
		
func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
