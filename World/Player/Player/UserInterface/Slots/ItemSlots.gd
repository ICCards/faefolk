extends GridContainer


onready var InventoryItem = load("res://InventoryLogic/InventoryItem.tscn")
onready var SlotClass = load("res://InventoryLogic/Slot.gd")


func _ready():
	var slots = self.get_children()
	for i in range(slots.size()):
		PlayerData.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].connect("mouse_entered", self, "hovered_slot", [slots[i]])
		slots[i].connect("mouse_exited", self, "exited_slot", [slots[i]])
		slots[i].slot_index = i
		slots[i].slotType = SlotClass.SlotType.COMBAT_HOTBAR
	initialize_slots()

func initialize_slots():
	var slots = self.get_children()
	for i in range(slots.size()):
		if slots[i].item:
			slots[i].removeFromSlot()
		if PlayerData.player_data["combat_hotbar"].has(str(i)):
			slots[i].initialize_item(PlayerData.player_data["combat_hotbar"][str(i)][0], PlayerData.player_data["combat_hotbar"][str(i)][1], PlayerData.player_data["combat_hotbar"][str(i)][2])

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
			if Server.player_node.state == 0:
				Sounds.play_hotbar_slot_selected_sound()
				PlayerData.hotbar_slot_selected(slot)

func right_click_slot(slot):
	if slot.item.item_quantity > 1:
		Sounds.play_pick_up_item_sound()
		var new_qt = int(slot.item.item_quantity / 2)
		PlayerData.add_item_quantity(slot, -int(slot.item.item_quantity / 2))
		slot.item.decrease_item_quantity(int(slot.item.item_quantity / 2))
		find_parent("UserInterface").holding_item = return_holding_item(slot.item.item_name, new_qt)
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

func return_holding_item(item_name, qt):
	var inventoryItem = InventoryItem.instance()
	inventoryItem.set_item(item_name, qt, null)
	find_parent("UserInterface").add_child(inventoryItem)
	return inventoryItem

func left_click_empty_slot(slot):
	PlayerData.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = null

func left_click_different_item(event: InputEvent, slot):
	PlayerData.remove_item(slot)
	PlayerData.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = temp_item

func left_click_same_item(slot):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= find_parent("UserInterface").holding_item.item_quantity:
		PlayerData.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity)
		slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null
	else:
		PlayerData.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot):
	PlayerData.remove_item(slot)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
