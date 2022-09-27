extends Control


onready var inventory_slots = $InventorySlots
onready var chest_slots = $ChestSlots
onready var hotbar_slots = $HotbarSlots
onready var locked_slots = $LockedSlots
const SlotClass = preload("res://InventoryLogic/Slot.gd")
var chest_id
var item

func _ready():
	var slots_in_inventory = inventory_slots.get_children()
	var slots_in_chest = chest_slots.get_children()
	var slots_in_hotbar = hotbar_slots.get_children()
	for i in range(slots_in_inventory.size()):
		slots_in_inventory[i].connect("gui_input", self, "slot_gui_input", [slots_in_inventory[i]])
		slots_in_inventory[i].connect("mouse_entered", self, "hovered_slot", [slots_in_inventory[i]])
		slots_in_inventory[i].connect("mouse_exited", self, "exited_slot", [slots_in_inventory[i]])
		slots_in_inventory[i].slot_index = i
		slots_in_inventory[i].slotType = SlotClass.SlotType.INVENTORY
	for i in range(slots_in_chest.size()):
		slots_in_chest[i].connect("gui_input", self, "slot_gui_input", [slots_in_chest[i]])
		slots_in_chest[i].connect("mouse_entered", self, "hovered_slot", [slots_in_chest[i]])
		slots_in_chest[i].connect("mouse_exited", self, "exited_slot", [slots_in_chest[i]])
		slots_in_chest[i].slot_index = i
		slots_in_chest[i].slotType = SlotClass.SlotType.CHEST
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
	chest_id = PlayerInventory.chest_id
	initialize_chest_data()
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
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1], PlayerInventory.hotbar[i][2])
	
	
func initialize_chest_data():
	var slots_in_chest = chest_slots.get_children()
	for i in range(slots_in_chest.size()):
		if slots_in_chest[i].item != null:
			slots_in_chest[i].removeFromSlot()
		if PlayerInventory.chests[chest_id].has(i):
			slots_in_chest[i].initialize_item(PlayerInventory.chests[chest_id][i][0], PlayerInventory.chests[chest_id][i][1], PlayerInventory.chests[chest_id][i][2])

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if slots[i].item != null:
			slots[i].removeFromSlot()
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1], PlayerInventory.inventory[i][2])


func hovered_slot(slot: SlotClass):
	if slot.item:
		slot.item.hover_item()
		item = slot.item.item_name

func exited_slot(slot: SlotClass):
	item = null
	if slot.item:
		slot.item.exit_item()

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
	var slots_in_chest = chest_slots.get_children()
	var slots_in_inventory = inventory_slots.get_children()
	var slots_in_hotbar = hotbar_slots.get_children()
	if slot.slotType == slot.SlotType.INVENTORY or slot.slotType == slot.SlotType.HOTBAR_INVENTORY:
		for i in range(slots_in_chest.size()):
			if not PlayerInventory.chests[chest_id].has(i):
				item = null
				PlayerInventory.remove_item(slot)
				PlayerInventory.add_item_to_empty_slot(slot.item, chest_slots.get_children()[i], chest_id)
				slot.removeFromSlot()
				initialize_chest_data()
				initialize_inventory()
				initialize_hotbar()
				return
	elif slot.slotType == slot.SlotType.CHEST:
			for i in range(slots_in_hotbar.size()):
				if not PlayerInventory.hotbar.has(i):
					item = null
					PlayerInventory.remove_item(slot, chest_id)
					PlayerInventory.add_item_to_empty_slot(slot.item, hotbar_slots.get_children()[i])
					slot.removeFromSlot()
					initialize_inventory()
					initialize_chest_data()
					initialize_hotbar()
					return
			for i in range(slots_in_inventory.size()):
				if not PlayerInventory.inventory.has(i):
					item = null
					PlayerInventory.remove_item(slot, chest_id)
					PlayerInventory.add_item_to_empty_slot(slot.item, inventory_slots.get_children()[i])
					slot.removeFromSlot()
					initialize_inventory()
					initialize_chest_data()
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
	find_parent("UserInterface").close_chest()
