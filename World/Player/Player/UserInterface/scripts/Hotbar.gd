extends Node2D

const SlotClass = preload("res://InventoryLogic/Slot.gd")
onready var hotbar_slots = $HotbarSlots
onready var slots = hotbar_slots.get_children()
var item = null
var adjusted_pos

func _ready():
	for i in range(slots.size()):
		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].connect("mouse_entered", self, "hovered_slot", [slots[i]])
		slots[i].connect("mouse_exited", self, "exited_slot", [slots[i]])
		slots[i].slotType = SlotClass.SlotType.HOTBAR
		slots[i].slot_index = i
	initialize_hotbar()

func hovered_slot(slot: SlotClass):
	if slot.item != null:
		item = slot.item.item_name

func exited_slot(slot: SlotClass):
	item = null

func _physics_process(delta):
	adjusted_description_position()
	if item != null and find_parent("UserInterface").holding_item == null:
		$ItemDescription.visible = true
		$ItemDescription.item_name = item
		$ItemDescription.position = adjusted_pos
		$ItemDescription.initialize()
	else:
		$ItemDescription.visible = false

func adjusted_description_position():
	yield(get_tree(), "idle_frame")
	var lines = $ItemDescription/ItemDescription.get_line_count()
	if lines >= 5:
		adjusted_pos =  Vector2(get_local_mouse_position().x + 40, -94 - (lines * 22))
	elif lines == 4:
		adjusted_pos =  Vector2(get_local_mouse_position().x + 40, -94 - (lines * 20))
	elif lines > 2:
		adjusted_pos =  Vector2(get_local_mouse_position().x + 40, -94 - (lines * 14))
	else:
		adjusted_pos =  Vector2(get_local_mouse_position().x + 40, -94)


func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])

func _input(_event):
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if PlayerInventory.viewInventoryMode == false and PlayerInventory.interactive_screen_mode == false:
				PlayerInventory.hotbar_slot_selected(slot)
			elif find_parent("UserInterface").holding_item != null:
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


