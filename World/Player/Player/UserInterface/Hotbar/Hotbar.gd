extends Control

const SlotClass = preload("res://InventoryLogic/Slot.gd")
onready var hotbar_slots = $HotbarSlots
onready var slots = hotbar_slots.get_children()
var item = null
var adjusted_pos

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
	CHEST
}

func _ready():
	for i in range(slots.size()):
		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].connect("mouse_entered", self, "hovered_slot", [slots[i]])
		slots[i].connect("mouse_exited", self, "exited_slot", [slots[i]])
		slots[i].slotType = SlotClass.SlotType.HOTBAR
		slots[i].slot_index = i
	initialize_hotbar()
	Stats.connect("tool_health_change", self, "update_tool_health")
	

func hovered_slot(slot: SlotClass):
	if slot.item:
		slot.item.hover_item()
		item = slot.item.item_name

func exited_slot(slot: SlotClass):
	item = null
	if slot.item and not (slot.slotType == SlotType.HOTBAR and PlayerInventory.active_item_slot == slot.slot_index):
		slot.item.exit_item()
		

func _physics_process(delta):
	adjusted_description_position()
	if item and find_parent("UserInterface").holding_item == null:
		$ItemDescription.item_category = JsonData.item_data[item]["ItemCategory"]
		$ItemDescription.visible = true
		$ItemDescription.item_name = item
		$ItemDescription.position = adjusted_pos
		$ItemDescription.initialize()
	else:
		$ItemDescription.visible = false


func adjusted_description_position():
	yield(get_tree(), "idle_frame")
#	var height = $ItemDescription/GridContainer.rect_size.y
#	adjusted_pos = Vector2(get_local_mouse_position().x + 45, -height)
	var lines = $ItemDescription/Body/ItemDescription.get_line_count()
	if lines == 8:
		adjusted_pos = Vector2(get_local_mouse_position().x + 45, -194)
	elif lines == 7:
		adjusted_pos = Vector2(get_local_mouse_position().x + 45, -168)
	elif lines == 6:
		adjusted_pos = Vector2(get_local_mouse_position().x + 45, -144)
	elif lines == 5:
		adjusted_pos = Vector2(get_local_mouse_position().x + 45, -118)
	elif lines == 4:
		adjusted_pos = Vector2(get_local_mouse_position().x + 45, -93)
	elif lines == 3:
		adjusted_pos = Vector2(get_local_mouse_position().x + 45, -66)
	else:
		adjusted_pos = Vector2(get_local_mouse_position().x + 45, -42)
	if item:
		if JsonData.item_data[item]["ItemCategory"] == "Food" or JsonData.item_data[item]["ItemCategory"] == "Fish":
			adjusted_pos += Vector2(0,-63)


func update_tool_health():
	if PlayerInventory.hotbar[PlayerInventory.active_item_slot][2] == 0 and PlayerInventory.hotbar[PlayerInventory.active_item_slot][0] != "stone watering can":
		slots[PlayerInventory.active_item_slot].removeFromSlot()
		PlayerInventory.remove_item(slots[PlayerInventory.active_item_slot])
		yield(get_tree().create_timer(0.1), "timeout")
		$SoundEffects.stream = Sounds.tool_break
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -18)
		$SoundEffects.play()
	else:
		slots[PlayerInventory.active_item_slot].initialize_item(PlayerInventory.hotbar[PlayerInventory.active_item_slot][0], PlayerInventory.hotbar[PlayerInventory.active_item_slot][1], PlayerInventory.hotbar[PlayerInventory.active_item_slot][2])
	

func initialize_hotbar():
	PlayerInventory.HotbarSlots = $HotbarSlots
	item = null
	for i in range(slots.size()):
		if slots[i].item != null:
			slots[i].removeFromSlot()
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1], PlayerInventory.hotbar[i][2])
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		slots[PlayerInventory.active_item_slot].item.set_init_hovered()
		
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

