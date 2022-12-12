extends Control

onready var inventory_slots = $InventorySlots
onready var tc_slots = $TcSlots
onready var hotbar_slots = $HotbarSlots
onready var locked_slots = $LockedSlots
onready var SlotClass = load("res://InventoryLogic/Slot.gd")
onready var InventoryItem = load("res://InventoryLogic/InventoryItem.tscn")

var id
var item

func _ready():
	var slots_in_inventory = inventory_slots.get_children()
	var slots_in_tc = tc_slots.get_children()
	var slots_in_hotbar = hotbar_slots.get_children()
	for i in range(slots_in_inventory.size()):
		slots_in_inventory[i].connect("gui_input", self, "slot_gui_input", [slots_in_inventory[i]])
		slots_in_inventory[i].connect("mouse_entered", self, "hovered_slot", [slots_in_inventory[i]])
		slots_in_inventory[i].connect("mouse_exited", self, "exited_slot", [slots_in_inventory[i]])
		slots_in_inventory[i].slot_index = i
		slots_in_inventory[i].slotType = SlotClass.SlotType.INVENTORY
	for i in range(slots_in_tc.size()):
		slots_in_tc[i].connect("gui_input", self, "slot_gui_input", [slots_in_tc[i]])
		slots_in_tc[i].connect("mouse_entered", self, "hovered_slot", [slots_in_tc[i]])
		slots_in_tc[i].connect("mouse_exited", self, "exited_slot", [slots_in_tc[i]])
		slots_in_tc[i].slot_index = i
		slots_in_tc[i].slotType = SlotClass.SlotType.TOOL_CABINET
	for i in range(slots_in_hotbar.size()):
		slots_in_hotbar[i].connect("gui_input", self, "slot_gui_input", [slots_in_hotbar[i]])
		slots_in_hotbar[i].connect("mouse_entered", self, "hovered_slot", [slots_in_hotbar[i]])
		slots_in_hotbar[i].connect("mouse_exited", self, "exited_slot", [slots_in_hotbar[i]])
		slots_in_hotbar[i].slot_index = i
		slots_in_hotbar[i].slotType = SlotClass.SlotType.HOTBAR_INVENTORY
	initialize()


func initialize():
	Server.player_node.destroy_placable_object()
	show()
	initialize_tc_data()
	initialize_inventory()
	initialize_hotbar()
	

func destroy():
	set_physics_process(false)
	$ItemDescription.queue_free()
	queue_free()

func _physics_process(delta):
	if item and not find_parent("UserInterface").holding_item:
		$ItemDescription.show()
		$ItemDescription.item_category = JsonData.item_data[item]["ItemCategory"]
		$ItemDescription.item_name = item
		$ItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
		$ItemDescription.initialize()
	else:
		$ItemDescription.hide()



func initialize_hotbar():
	var slots = hotbar_slots.get_children()
	for i in range(slots.size()):
		if slots[i].item != null:
			slots[i].removeFromSlot()
		if PlayerData.hotbar.has(i):
			slots[i].initialize_item(PlayerData.hotbar[i][0], PlayerData.hotbar[i][1], PlayerData.hotbar[i][2])
	
	
func initialize_tc_data():
	var slots_in_tc = tc_slots.get_children()
	for i in range(slots_in_tc.size()):
		if slots_in_tc[i].item != null:
			slots_in_tc[i].removeFromSlot()
		if PlayerData.tool_cabinets[id].has(i):
			slots_in_tc[i].initialize_item(PlayerData.tool_cabinets[id][i][0], PlayerData.tool_cabinets[id][i][1], PlayerData.tool_cabinets[id][i][2])

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if slots[i].item != null:
			slots[i].removeFromSlot()
		if PlayerData.inventory.has(i):
			slots[i].initialize_item(PlayerData.inventory[i][0], PlayerData.inventory[i][1], PlayerData.inventory[i][2])


func hovered_slot(slot):
	if slot.item:
		slot.item.hover_item()
		item = slot.item.item_name

func exited_slot(slot):
	item = null
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
		var new_qt = slot.item.item_quantity / 2
		PlayerData.decrease_item_quantity(slot, slot.item.item_quantity / 2, id)
		slot.item.decrease_item_quantity(slot.item.item_quantity / 2)
		find_parent("UserInterface").holding_item = return_holding_item(slot.item.item_name, new_qt)
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

func return_holding_item(item_name, qt):
	var inventoryItem = InventoryItem.instance()
	inventoryItem.set_item(item_name, qt, null)
	find_parent("UserInterface").add_child(inventoryItem)
	return inventoryItem


func left_click_empty_slot(slot):
	PlayerData.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, id)
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = null


func left_click_different_item(event: InputEvent, slot):
	PlayerData.remove_item(slot, id)
	PlayerData.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, id)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = temp_item


func left_click_same_item(slot):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= find_parent("UserInterface").holding_item.item_quantity:
		PlayerData.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity, id)
		slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null
	else:
		PlayerData.add_item_quantity(slot, able_to_add, id)
		slot.item.add_item_quantity(able_to_add)
		find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)


func left_click_not_holding(slot):
	var slots_in_tc = tc_slots.get_children()
	var slots_in_inventory = inventory_slots.get_children()
	var slots_in_hotbar = hotbar_slots.get_children()
	if slot.slotType == slot.SlotType.INVENTORY or slot.slotType == slot.SlotType.HOTBAR_INVENTORY:
		for i in range(slots_in_tc.size()):
			if not PlayerData.tool_cabinets[id].has(i):
				item = null
				PlayerData.remove_item(slot)
				PlayerData.add_item_to_empty_slot(slot.item, tc_slots.get_children()[i], id)
				slot.removeFromSlot()
				initialize_tc_data()
				initialize_inventory()
				initialize_hotbar()
				return
	elif slot.slotType == slot.SlotType.TOOL_CABINET:
			for i in range(slots_in_hotbar.size()):
				if not PlayerData.hotbar.has(i):
					item = null
					PlayerData.remove_item(slot, id)
					PlayerData.add_item_to_empty_slot(slot.item, hotbar_slots.get_children()[i])
					slot.removeFromSlot()
					initialize_inventory()
					initialize_tc_data()
					initialize_hotbar()
					return
			for i in range(slots_in_inventory.size()):
				if not PlayerData.inventory.has(i):
					item = null
					PlayerData.remove_item(slot, id)
					PlayerData.add_item_to_empty_slot(slot.item, inventory_slots.get_children()[i])
					slot.removeFromSlot()
					initialize_inventory()
					initialize_tc_data()
					initialize_hotbar()
					return
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()


func open_trash_can():
	$Tween.interpolate_property($Trash/Top, "rotation_degrees",
		$Trash/Top.rotation_degrees, 90, 0.35,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func close_trash_can():
	$Tween.interpolate_property($Trash/Top, "rotation_degrees",
		$Trash/Top.rotation_degrees, 0, 0.35,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_TrashButton_mouse_entered():
	open_trash_can()

func _on_TrashButton_mouse_exited():
	close_trash_can()

func _on_TrashButton_pressed():
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null


func _on_btn_pressed():
	find_parent("UserInterface").close_tc(id)

