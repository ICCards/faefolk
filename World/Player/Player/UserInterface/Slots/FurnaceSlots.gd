extends Control

@onready var SlotClass = load("res://InventoryLogic/Slot.gd")
@onready var InventoryItem = load("res://InventoryLogic/InventoryItem.tscn")


func _ready():
	var slots = self.get_children()
	for i in range(self.get_children().size()):
		slots[i].connect("gui_input",Callable(self,"slot_gui_input").bind(slots[i]))
		slots[i].connect("mouse_entered",Callable(self,"hovered_slot").bind(slots[i]))
		slots[i].connect("mouse_exited",Callable(self,"exited_slot").bind(slots[i]))
		slots[i].slot_index = i
		slots[i].slotType = SlotClass.SlotType.FURNACE
	initialize_slots()
	
func initialize_slots():
	var slots = self.get_children()
	for i in range(slots.size()):
		if slots[i].item != null:
			slots[i].removeFromSlot()
		if PlayerData.player_data["furnaces"][get_parent().id].has(str(i)):
			slots[i].initialize_item(PlayerData.player_data["furnaces"][get_parent().id][str(i)][0], PlayerData.player_data["furnaces"][get_parent().id][str(i)][1], PlayerData.player_data["furnaces"][get_parent().id][str(i)][2])

func able_to_put_into_slot(slot):
	var holding_item = find_parent("UserInterface").holding_item
	if holding_item == null:
		return true
	var holding_item_name = holding_item.item_name 
	if slot.slot_index == 0 and slot.name == "FuelSlot": # fuel
		return holding_item_name == "wood" or holding_item_name == "coal"
	elif (slot.slot_index == 1 or slot.slot_index == 2) and slot.name.substr(0,7) == "OreSlot": # ingredients
		return holding_item_name == "iron ore" or holding_item_name == "bronze ore" or holding_item_name == "gold ore"
	elif slot.slot_index == 3 or slot.slot_index == 4 or slot.slot_index == 5: # yield
		return false

func hovered_slot(slot):
	if slot.item:
		get_parent().hovered_item = slot.item.item_name

func exited_slot(slot):
	get_parent().hovered_item = null

func slot_gui_input(event: InputEvent, slot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
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
		elif event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
			if slot.item and not find_parent("UserInterface").holding_item:
				right_click_slot(slot)


func right_click_slot(slot):
	if slot.item.item_quantity > 1:
		var new_qt = int(slot.item.item_quantity / 2)
		PlayerData.decrease_item_quantity(slot, int(slot.item.item_quantity / 2), get_parent().id)
		slot.item.decrease_item_quantity(int(slot.item.item_quantity / 2))
		find_parent("UserInterface").holding_item = return_holding_item(slot.item.item_name, new_qt)
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
		if slot.name == "FuelSlot" or slot.name == "OreSlot1" or slot.name == "OreSlot2":
			get_parent().check_if_furnace_active()
		

func return_holding_item(item_name, qt):
	var inventoryItem = InventoryItem.instantiate()
	inventoryItem.set_item(item_name, qt, null)
	find_parent("UserInterface").add_child(inventoryItem)
	return inventoryItem


func left_click_empty_slot(slot):
	if able_to_put_into_slot(slot):
		PlayerData.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, get_parent().id)
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = null
		if slot.name == "FuelSlot" or slot.name == "OreSlot1" or slot.name == "OreSlot2":
			get_parent().check_if_furnace_active()

func left_click_different_item(event: InputEvent, slot):
	if able_to_put_into_slot(slot):
		PlayerData.remove_item(slot, get_parent().id)
		PlayerData.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, get_parent().id)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = temp_item
		if slot.name == "FuelSlot" or slot.name == "OreSlot1" or slot.name == "OreSlot2":
			get_parent().check_if_furnace_active()

func left_click_same_item(slot):
	if able_to_put_into_slot(slot):
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
		if slot.name == "FuelSlot" or slot.name == "OreSlot1" or slot.name == "OreSlot2":
			get_parent().check_if_furnace_active()

func left_click_not_holding(slot):
	PlayerData.remove_item(slot, get_parent().id)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
	if slot.name == "FuelSlot" or slot.name == "OreSlot1" or slot.name == "OreSlot2":
		get_parent().check_if_furnace_active()
