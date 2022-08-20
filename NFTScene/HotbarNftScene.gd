extends Node2D


const SlotClass = preload("res://NFTScene/SlotNftScene.gd")
onready var hotbar_slots = $HotbarSlots
onready var slots = hotbar_slots.get_children()
var item = null
var adjusted_pos

func _ready():
	for i in range(slots.size()):
		Constants.PlayerInventoryNftScene.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].connect("mouse_entered", self, "hovered_slot", [slots[i]])
		slots[i].connect("mouse_exited", self, "exited_slot", [slots[i]])
		slots[i].slotType = SlotClass.SlotType.HOTBAR
		slots[i].slot_index = i
	initialize_hotbar()
	Stats.connect("tool_health_change", self, "update_tool_health")
	

func hovered_slot(slot: SlotClass):
	if slot.item != null:
		slot.item.hover_item()
		item = slot.item.item_name

func exited_slot(slot: SlotClass):
	if slot.item != null:
		slot.item.exit_item()
		item = null

func _physics_process(delta):
	adjusted_description_position()
	if item != null and find_parent("UserInterfaceNftScene").holding_item == null:
		$ItemDescription.visible = true
		$ItemDescription.item_name = item
		$ItemDescription.position = adjusted_pos
		$ItemDescription.initialize()
	else:
		item = null
		$ItemDescription.visible = false


func adjusted_description_position():
	yield(get_tree(), "idle_frame")
	var lines = $ItemDescription/ItemDescription.get_line_count()
	if lines == 7:
		adjusted_pos = Vector2(get_local_mouse_position().x + 40, -145)
	elif lines == 6:
		adjusted_pos = Vector2(get_local_mouse_position().x + 40, -126)
	elif lines == 5:
		adjusted_pos = Vector2(get_local_mouse_position().x + 40, -107)
	elif lines == 4:
		adjusted_pos = Vector2(get_local_mouse_position().x + 40, -87)
	elif lines == 3:
		adjusted_pos = Vector2(get_local_mouse_position().x + 40, -68)
	else:
		adjusted_pos = Vector2(get_local_mouse_position().x + 40, -51)



func initialize_hotbar():
	for i in range(slots.size()):
		if slots[i].item != null:
			slots[i].removeFromSlot()
		if Constants.PlayerInventoryNftScene.hotbar.has(i):
			slots[i].initialize_item(Constants.PlayerInventoryNftScene.hotbar[i][0], Constants.PlayerInventoryNftScene.hotbar[i][1], Constants.PlayerInventoryNftScene.hotbar[i][2])


func _input(_event):
	if find_parent("UserInterfaceNftScene").holding_item:
		find_parent("UserInterfaceNftScene").holding_item.global_position = get_global_mouse_position()

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if Constants.PlayerInventoryNftScene.viewInventoryMode == false:
				Constants.PlayerInventoryNftScene.hotbar_slot_selected(slot)
			elif find_parent("UserInterfaceNftScene").holding_item != null:
				if !slot.item:
					left_click_empty_slot(slot)
				else:
					if find_parent("UserInterfaceNftScene").holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)

func left_click_empty_slot(slot: SlotClass):
	Constants.PlayerInventoryNftScene.add_item_to_empty_slot(find_parent("UserInterfaceNftScene").holding_item, slot)
	slot.putIntoSlot(find_parent("UserInterfaceNftScene").holding_item)
	find_parent("UserInterfaceNftScene").holding_item = null
	
func left_click_different_item(event: InputEvent, slot: SlotClass):
	Constants.PlayerInventoryNftScene.remove_item(slot)
	Constants.PlayerInventoryNftScene.add_item_to_empty_slot(find_parent("UserInterfaceNftScene").holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterfaceNftScene").holding_item)
	find_parent("UserInterfaceNftScene").holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= find_parent("UserInterfaceNftScene").holding_item.item_quantity:
		Constants.PlayerInventoryNftScene.add_item_quantity(slot, find_parent("UserInterfaceNftScene").holding_item.item_quantity)
		slot.item.add_item_quantity(find_parent("UserInterfaceNftScene").holding_item.item_quantity)
		find_parent("UserInterfaceNftScene").holding_item.queue_free()
		find_parent("UserInterfaceNftScene").holding_item = null
	else:
		Constants.PlayerInventoryNftScene.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		find_parent("UserInterfaceNftScene").holding_item.decrease_item_quantity(able_to_add)
		
func left_click_not_holding(slot: SlotClass):
	Constants.PlayerInventoryNftScene.remove_item(slot)
	find_parent("UserInterfaceNftScene").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterfaceNftScene").holding_item.global_position = get_global_mouse_position()


