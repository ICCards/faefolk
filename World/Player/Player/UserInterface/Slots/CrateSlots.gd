extends GridContainer

@onready var InventoryItem = load("res://InventoryLogic/InventoryItem.tscn")
@onready var SlotClass = load("res://InventoryLogic/Slot.gd")

func _ready():
	var slots = self.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input",Callable(self,"slot_gui_input").bind(slots[i]))
		slots[i].connect("mouse_entered",Callable(self,"hovered_slot").bind(slots[i]))
		slots[i].connect("mouse_exited",Callable(self,"exited_slot").bind(slots[i]))
		slots[i].slot_index = i
		slots[i].slotType = SlotClass.SlotType.CHEST
	initialize_slots()

func initialize_slots():
	var slots = self.get_children()
	for i in range(slots.size()):
		if slots[i].item:
			slots[i].removeFromSlot()
		if PlayerData.player_data["ui_slots"][get_parent().id].has(str(i)):
			slots[i].initialize_item(PlayerData.player_data["ui_slots"][get_parent().id][str(i)][0], PlayerData.player_data["ui_slots"][get_parent().id][str(i)][1], PlayerData.player_data["ui_slots"][get_parent().id][str(i)][2])
		
func hovered_slot(slot):
	if slot.item:
		#slot.item.hover_item()
		get_parent().hovered_item = slot.item.item_name

func exited_slot(slot):
	get_parent().hovered_item = null
#	if slot.item:
#		slot.item.exit_item()

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
				left_click_not_holding_chest(slot)
		elif event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
			if slot.item and not find_parent("UserInterface").holding_item:
				right_click_slot(slot)

func right_click_slot(slot):
	if slot.item.item_quantity > 1:
		Sounds.play_pick_up_item_sound()
		var new_qt = int(slot.item.item_quantity / 2)
		PlayerData.add_item_quantity(slot, -int(slot.item.item_quantity / 2), get_parent().id)
		slot.item.decrease_item_quantity(int(slot.item.item_quantity / 2))
		find_parent("UserInterface").holding_item = return_holding_item(slot.item.item_name, new_qt)
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

func return_holding_item(item_name, qt):
	var inventoryItem = InventoryItem.instantiate()
	inventoryItem.set_item(item_name, qt, null)
	find_parent("UserInterface").add_child(inventoryItem)
	return inventoryItem

func left_click_empty_slot(slot):
	Sounds.play_put_down_item_sound()
	PlayerData.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, get_parent().id)
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = null

func left_click_different_item(event: InputEvent, slot):
	Sounds.play_pick_up_item_sound()
	PlayerData.remove_item(slot, get_parent().id)
	PlayerData.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, get_parent().id)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = temp_item

func left_click_same_item(slot):
	Sounds.play_pick_up_item_sound()
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if stack_size == 1:
		PlayerData.remove_item(slot)
		PlayerData.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = temp_item
	else:
		if able_to_add >= find_parent("UserInterface").holding_item.item_quantity:
			PlayerData.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity, get_parent().id)
			slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
			find_parent("UserInterface").holding_item.queue_free()
			find_parent("UserInterface").holding_item = null
		else:
			PlayerData.add_item_quantity(slot, able_to_add, get_parent().id)
			slot.item.add_item_quantity(able_to_add)
			find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot):
	Sounds.play_pick_up_item_sound()
	PlayerData.remove_item(slot, get_parent().id)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
	
	
func auto_add_to_hotbar_slot(slot_clicked,i):
	Sounds.play_auto_add_chest_sound()
	var stack_size = int(JsonData.item_data[slot_clicked.item.item_name]["StackSize"])
	var able_to_add = stack_size - PlayerData.player_data["hotbar"][str(i)][1]
	if able_to_add >= slot_clicked.item.item_quantity:
		PlayerData.remove_item(slot_clicked, get_parent().id)
		PlayerData.add_item_quantity(get_node("../HotbarInventorySlots").get_children()[i], slot_clicked.item.item_quantity)
		slot_clicked.removeFromSlot()
		get_parent().initialize()
	else:
		PlayerData.add_item_quantity(get_node("../HotbarInventorySlots").get_children()[i], able_to_add)
		PlayerData.decrease_item_quantity(slot_clicked,able_to_add,get_parent().id)
		slot_clicked.item.decrease_item_quantity(able_to_add)
		get_parent().initialize()

func auto_add_to_inventory_slot(slot_clicked,i):
	Sounds.play_auto_add_chest_sound()
	var stack_size = int(JsonData.item_data[slot_clicked.item.item_name]["StackSize"])
	var able_to_add = stack_size - PlayerData.player_data["inventory"][str(i)][1]
	if able_to_add >= slot_clicked.item.item_quantity:
		PlayerData.remove_item(slot_clicked, get_parent().id)
		PlayerData.add_item_quantity(get_node("../InventorySlots").get_children()[i], slot_clicked.item.item_quantity)
		slot_clicked.removeFromSlot()
		get_parent().initialize()
	else:
		PlayerData.add_item_quantity(get_node("../InventorySlots").get_children()[i], able_to_add)
		PlayerData.decrease_item_quantity(slot_clicked,able_to_add,get_parent().id)
		slot_clicked.item.decrease_item_quantity(able_to_add)
		get_parent().initialize()


func left_click_not_holding_chest(slot):
	for i in range(get_node("../HotbarInventorySlots").get_children().size()):
		if PlayerData.player_data["hotbar"].has(str(i)):
			if PlayerData.player_data["hotbar"][str(i)][0] == slot.item.item_name and not PlayerData.player_data["hotbar"][str(i)][1] == int(JsonData.item_data[slot.item.item_name]["StackSize"]):
				auto_add_to_hotbar_slot(slot,i)
				return
	for i in range(get_node("../InventorySlots").get_children().size()):
		if PlayerData.player_data["inventory"].has(str(i)):
			if PlayerData.player_data["inventory"][str(i)][0] == slot.item.item_name and not PlayerData.player_data["inventory"][str(i)][1] == int(JsonData.item_data[slot.item.item_name]["StackSize"]):
				auto_add_to_inventory_slot(slot,i)
				return
	for i in range(get_node("../HotbarInventorySlots").get_children().size()):
		if not PlayerData.player_data["hotbar"].has(str(i)): # add to empty hotbar slot
			Sounds.play_pick_up_item_sound()
			PlayerData.remove_item(slot, get_parent().id)
			PlayerData.add_item_to_empty_slot(slot.item, get_node("../HotbarInventorySlots").get_children()[i])
			slot.removeFromSlot()
			get_parent().initialize()
			return
	for i in range(get_node("../InventorySlots").get_children().size()):
		if not PlayerData.player_data["inventory"].has(str(i)): # add to empty inventory slot
			Sounds.play_pick_up_item_sound()
			PlayerData.remove_item(slot, get_parent().id)
			PlayerData.add_item_to_empty_slot(slot.item, get_node("../InventorySlots").get_children()[i])
			slot.removeFromSlot()
			get_parent().initialize()
			return
	left_click_not_holding(slot)


