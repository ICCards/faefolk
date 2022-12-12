extends Control

onready var InventoryItem = load("res://InventoryLogic/InventoryItem.tscn")
onready var SlotClass = load("res://InventoryLogic/Slot.gd")

onready var fuel_slot = $FuelSlot
onready var ingredient_slot1 = $Ingredient1
onready var ingredient_slot2 = $Ingredient2
onready var ingredient_slot3 = $Ingredient3
onready var yield_slot1 = $YieldSlot1
onready var yield_slot2 = $YieldSlot2
onready var coal_yield_slot = $CoalYieldSlot


func _ready():
	initialize_locked_slots()
	initialize_slots()

func initialize_locked_slots():
	var slots_in_stove = self.get_children()
	if get_parent().level == "1":
		$Ingredient2/LockSlot.show()
		$Ingredient3/LockSlot.show()
		for i in range(slots_in_stove.size()):
			if i != 2 and i != 3:
				slots_in_stove[i].connect("gui_input", self, "slot_gui_input", [slots_in_stove[i]])
				slots_in_stove[i].connect("mouse_entered", self, "hovered_slot", [slots_in_stove[i]])
				slots_in_stove[i].connect("mouse_exited", self, "exited_slot", [slots_in_stove[i]])
			slots_in_stove[i].slot_index = i
			slots_in_stove[i].slotType = SlotClass.SlotType.STOVE
	elif get_parent().level == "2":
		$Ingredient3/LockSlot.show()
		for i in range(slots_in_stove.size()):
			if i != 3:
				slots_in_stove[i].connect("gui_input", self, "slot_gui_input", [slots_in_stove[i]])
				slots_in_stove[i].connect("mouse_entered", self, "hovered_slot", [slots_in_stove[i]])
				slots_in_stove[i].connect("mouse_exited", self, "exited_slot", [slots_in_stove[i]])
			slots_in_stove[i].slot_index = i
			slots_in_stove[i].slotType = SlotClass.SlotType.STOVE
	else:
		for i in range(slots_in_stove.size()):
			slots_in_stove[i].connect("gui_input", self, "slot_gui_input", [slots_in_stove[i]])
			slots_in_stove[i].connect("mouse_entered", self, "hovered_slot", [slots_in_stove[i]])
			slots_in_stove[i].connect("mouse_exited", self, "exited_slot", [slots_in_stove[i]])
			slots_in_stove[i].slot_index = i
			slots_in_stove[i].slotType = SlotClass.SlotType.STOVE

func initialize_slots():
	var slots = self.get_children()
	for i in range(slots.size()):
		if slots[i].item:
			slots[i].removeFromSlot()
		if PlayerData.player_data["stoves"][get_parent().id].has(str(i)):
			slots[i].initialize_item(PlayerData.player_data["stoves"][get_parent().id][str(i)][0], PlayerData.player_data["stoves"][get_parent().id][str(i)][1], PlayerData.player_data["stoves"][get_parent().id][str(i)][2])

func able_to_put_into_slot(slot):
	var holding_item = find_parent("UserInterface").holding_item
	if holding_item == null:
		return true
	var holding_item_name = holding_item.item_name 
	var holding_item_category = JsonData.item_data[holding_item_name]["ItemCategory"]
	if slot.slot_index == 0 and slot.name == "FuelSlot": # fuel
		return holding_item_name == "wood" or holding_item_name == "coal"
	elif (slot.slot_index == 1 or slot.slot_index == 2 or slot.slot_index == 3) and slot.name.substr(0,10) == "Ingredient": # ingredients
		return holding_item_category == "Crop" or holding_item_category == "Fish" or holding_item_category == "Food"
	elif slot.slotType == SlotClass.SlotType.STOVE and (slot.slot_index == 4 or slot.slot_index == 5 or slot.slot_index == 6): # yield
		return false
	return true

func hovered_slot(slot):
	if slot.item:
		slot.item.hover_item()
		get_parent().hovered_item = slot.item.item_name

func exited_slot(slot):
	get_parent().hovered_item = null
	if slot.item:
		slot.item.exit_item()

func slot_gui_input(event: InputEvent, slot):
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
		elif event.button_index == BUTTON_RIGHT && event.pressed:
			if slot.item and not find_parent("UserInterface").holding_item:
				right_click_slot(slot)

func right_click_slot(slot):
	if slot.item.item_quantity > 1:
		var new_qt = int(slot.item.item_quantity / 2)
		PlayerData.add_item_quantity(slot, -int(slot.item.item_quantity / 2), get_parent().id)
		slot.item.decrease_item_quantity(int(slot.item.item_quantity / 2))
		find_parent("UserInterface").holding_item = return_holding_item(slot.item.item_name, new_qt)
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
		get_parent().check_valid_recipe()

func return_holding_item(item_name, qt):
	var inventoryItem = InventoryItem.instance()
	inventoryItem.set_item(item_name, qt, null)
	find_parent("UserInterface").add_child(inventoryItem)
	return inventoryItem

func left_click_empty_slot(slot):
	if able_to_put_into_slot(slot):
		PlayerData.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, get_parent().id)
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = null
		get_parent().check_valid_recipe()

func left_click_different_item(event: InputEvent, slot):
	if able_to_put_into_slot(slot):
		PlayerData.remove_item(slot, get_parent().id)
		PlayerData.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, get_parent().id)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = temp_item
		get_parent().check_valid_recipe()

func left_click_same_item(slot):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= find_parent("UserInterface").holding_item.item_quantity:
		PlayerData.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity, get_parent().id)
		slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null
	else:
		PlayerData.add_item_quantity(slot, able_to_add, get_parent().id)
		slot.item.add_item_quantity(able_to_add)
		find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)
	get_parent().check_valid_recipe()

func left_click_not_holding(slot):
	PlayerData.remove_item(slot, get_parent().id)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
	get_parent().check_valid_recipe()
