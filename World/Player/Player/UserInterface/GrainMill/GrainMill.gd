extends Control

var item
var dragging = false
var id
var level

onready var hotbar_slots = $HotbarSlots
onready var inventory_slots = $InventorySlots
onready var grain_mill_slots = $GrainMillSlots

const SlotClass = preload("res://InventoryLogic/Slot.gd")
onready var InventoryItem = preload("res://InventoryLogic/InventoryItem.tscn")

func _ready():
	var slots_in_inventory = inventory_slots.get_children()
	var slots_in_hotbar = hotbar_slots.get_children()
	for i in range(slots_in_inventory.size()):
		slots_in_inventory[i].connect("gui_input", self, "slot_gui_input", [slots_in_inventory[i]])
		slots_in_inventory[i].connect("mouse_entered", self, "hovered_slot", [slots_in_inventory[i]])
		slots_in_inventory[i].connect("mouse_exited", self, "exited_slot", [slots_in_inventory[i]])
		slots_in_inventory[i].slot_index = i
		slots_in_inventory[i].slotType = SlotClass.SlotType.INVENTORY
	for i in range(slots_in_hotbar.size()):
		slots_in_hotbar[i].connect("gui_input", self, "slot_gui_input", [slots_in_hotbar[i]])
		slots_in_hotbar[i].connect("mouse_entered", self, "hovered_slot", [slots_in_hotbar[i]])
		slots_in_hotbar[i].connect("mouse_exited", self, "exited_slot", [slots_in_hotbar[i]])
		slots_in_hotbar[i].slot_index = i
		slots_in_hotbar[i].slotType = SlotClass.SlotType.HOTBAR_INVENTORY
	initialize_locked_slots()
	initialize()
	
func initialize_locked_slots():
	var slots_in_grain_mill = grain_mill_slots.get_children()
	if level == "1":
		$GrainMillSlots/SugarCaneSlot/LockSlot.show()
		$GrainMillSlots/CornSlot/LockSlot.show()
		for i in range(slots_in_grain_mill.size()):
			if i != 1 and i != 2:
				slots_in_grain_mill[i].connect("gui_input", self, "slot_gui_input", [slots_in_grain_mill[i]])
				slots_in_grain_mill[i].connect("mouse_entered", self, "hovered_slot", [slots_in_grain_mill[i]])
				slots_in_grain_mill[i].connect("mouse_exited", self, "exited_slot", [slots_in_grain_mill[i]])
			slots_in_grain_mill[i].slot_index = i
			slots_in_grain_mill[i].slotType = SlotClass.SlotType.GRAIN_MILL
	elif level == "2":
		$GrainMillSlots/SugarCaneSlot/LockSlot.show()
		for i in range(slots_in_grain_mill.size()):
			if i != 2:
				slots_in_grain_mill[i].connect("gui_input", self, "slot_gui_input", [slots_in_grain_mill[i]])
				slots_in_grain_mill[i].connect("mouse_entered", self, "hovered_slot", [slots_in_grain_mill[i]])
				slots_in_grain_mill[i].connect("mouse_exited", self, "exited_slot", [slots_in_grain_mill[i]])
			slots_in_grain_mill[i].slot_index = i
			slots_in_grain_mill[i].slotType = SlotClass.SlotType.GRAIN_MILL
	else:
		for i in range(slots_in_grain_mill.size()):
			slots_in_grain_mill[i].connect("gui_input", self, "slot_gui_input", [slots_in_grain_mill[i]])
			slots_in_grain_mill[i].connect("mouse_entered", self, "hovered_slot", [slots_in_grain_mill[i]])
			slots_in_grain_mill[i].connect("mouse_exited", self, "exited_slot", [slots_in_grain_mill[i]])
			slots_in_grain_mill[i].slot_index = i
			slots_in_grain_mill[i].slotType = SlotClass.SlotType.GRAIN_MILL

func initialize():
	Server.player_node.destroy_placable_object()
	item = null
	$Title.text = "Grain mill #" + str(level) + ":"
	show()
	initialize_hotbar()
	initialize_inventory()
	initialize_grain_mill_data()
	
	
func destroy():
	set_physics_process(false)
	$ItemDescription.queue_free()
	queue_free()
	
func able_to_put_into_slot(slot: SlotClass):
	var holding_item = find_parent("UserInterface").holding_item
	if holding_item == null:
		return true
	var holding_item_name = holding_item.item_name 
	if slot.slot_index == 0 and slot.name == "WheatSlot" and not $GrainMillSlots/CornSlot.item and not $GrainMillSlots/SugarCaneSlot.item and not $GrainMillSlots/YieldSlot.item:
		return holding_item_name == "wheat"
	elif slot.slot_index == 1 and slot.name == "CornSlot" and not $GrainMillSlots/WheatSlot.item and not $GrainMillSlots/SugarCaneSlot.item and not $GrainMillSlots/YieldSlot.item:
		return holding_item_name == "corn"
	elif slot.slot_index == 2 and slot.name == "SugarCaneSlot" and not $GrainMillSlots/WheatSlot.item and not $GrainMillSlots/CornSlot.item and not $GrainMillSlots/YieldSlot.item:
		return holding_item_name == "sugar cane"
	elif slot.slotType == SlotClass.SlotType.GRAIN_MILL:
		return false
	return true

func craft():
	if $GrainMillSlots/WheatSlot.item:
		add_to_yield_slot("wheat flour")
		if $GrainMillSlots/WheatSlot.item.item_quantity -1 != 0:
			$GrainMillSlots/WheatSlot.item.decrease_item_quantity(1)
			PlayerInventory.add_item_quantity($GrainMillSlots/WheatSlot, -1, id)
		else:
			$GrainMillSlots/WheatSlot.removeFromSlot()
			PlayerInventory.remove_item($GrainMillSlots/WheatSlot, id)
	elif $GrainMillSlots/CornSlot.item:
		add_to_yield_slot("corn flour")
		if $GrainMillSlots/CornSlot.item.item_quantity -1 != 0:
			$GrainMillSlots/CornSlot.item.decrease_item_quantity(1)
			PlayerInventory.add_item_quantity($GrainMillSlots/CornSlot, -1, id)
		else:
			$GrainMillSlots/CornSlot.removeFromSlot()
			PlayerInventory.remove_item($GrainMillSlots/CornSlot, id)
	elif $GrainMillSlots/SugarCaneSlot.item:
		add_to_yield_slot("sugar")
		if $GrainMillSlots/SugarCaneSlot.item.item_quantity -1 != 0:
			$GrainMillSlots/SugarCaneSlot.item.decrease_item_quantity(1)
			PlayerInventory.add_item_quantity($GrainMillSlots/SugarCaneSlot, -1, id)
		else:
			$GrainMillSlots/SugarCaneSlot.removeFromSlot()
			PlayerInventory.remove_item($GrainMillSlots/SugarCaneSlot, id)


func add_to_yield_slot(item_name):
	if not $GrainMillSlots/YieldSlot.item:
		$GrainMillSlots/YieldSlot.initialize_item(item_name, 1, null)
		PlayerInventory.grain_mills[id][3] = [item_name, 1, null]
	else:
		PlayerInventory.add_item_quantity($GrainMillSlots/YieldSlot, 1, id)
		$GrainMillSlots/YieldSlot.item.add_item_quantity(1)

func _physics_process(delta):
	if item and not find_parent("UserInterface").holding_item:
		$ItemDescription.show()
		$ItemDescription.item_category = JsonData.item_data[item]["ItemCategory"]
		$ItemDescription.item_name = item
		$ItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
		$ItemDescription.initialize()
	else:
		$ItemDescription.hide()

func initialize_grain_mill_data():
	var slots_in_grain_mill = grain_mill_slots.get_children()
	for i in range(slots_in_grain_mill.size()):
		if slots_in_grain_mill[i].item != null:
			slots_in_grain_mill[i].removeFromSlot()
		if PlayerInventory.grain_mills_dict[id].has(i):
			slots_in_grain_mill[i].initialize_item(PlayerInventory.grain_mills_dict[id][i][0], PlayerInventory.grain_mills_dict[id][i][1], PlayerInventory.grain_mills_dict[id][i][2])

func initialize_hotbar():
	var slots = hotbar_slots.get_children()
	for i in range(slots.size()):
		if slots[i].item != null:
			slots[i].removeFromSlot()
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1], PlayerInventory.hotbar[i][2])

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if slots[i].item != null:
			slots[i].removeFromSlot()
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1], PlayerInventory.inventory[i][2])



func hovered_slot(slot: SlotClass):
	if slot.item and not $GrainMillCrank.dragging:
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
		elif event.button_index == BUTTON_RIGHT && event.pressed:
			if slot.item and not find_parent("UserInterface").holding_item:
				right_click_slot(slot)

func right_click_slot(slot):
	if slot.item.item_quantity > 1:
		var new_qt = int(slot.item.item_quantity / 2)
		PlayerInventory.decrease_item_quantity(slot, slot.item.item_quantity / 2)
		slot.item.decrease_item_quantity(slot.item.item_quantity / 2)
		find_parent("UserInterface").holding_item = return_holding_item(slot.item.item_name, new_qt)
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

func return_holding_item(item_name, qt):
	var inventoryItem = InventoryItem.instance()
	inventoryItem.set_item(item_name, qt, null)
	find_parent("UserInterface").add_child(inventoryItem)
	return inventoryItem


func left_click_empty_slot(slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, id)
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = null

func left_click_different_item(event: InputEvent, slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	if able_to_put_into_slot(slot):
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= find_parent("UserInterface").holding_item.item_quantity:
			PlayerInventory.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity,  id)
			slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
			find_parent("UserInterface").holding_item.queue_free()
			find_parent("UserInterface").holding_item = null
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add, id)
			slot.item.add_item_quantity(able_to_add)
			find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot, id)
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


func _on_BackgroundButton_pressed():
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").items_to_drop.append([find_parent("UserInterface").holding_item.item_name, find_parent("UserInterface").holding_item.item_quantity, find_parent("UserInterface").holding_item.item_health])
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null


func _on_ExitButton_pressed():
	get_parent().close_grain_mill()




