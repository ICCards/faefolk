extends Control

onready var InventoryItem = load("res://InventoryLogic/InventoryItem.tscn")
onready var SlotClass = load("res://InventoryLogic/Slot.gd")
onready var inventory_slots = $InventorySlots
onready var hotbar_slots = $HotbarSlots
var item

func _ready():
	PlayerInventory.InventorySlots = $InventorySlots
	var i_slots = inventory_slots.get_children()
	for i in range(i_slots.size()):
		i_slots[i].connect("gui_input", self, "slot_gui_input", [i_slots[i]])
		i_slots[i].connect("mouse_entered", self, "hovered_slot", [i_slots[i]])
		i_slots[i].connect("mouse_exited", self, "exited_slot", [i_slots[i]])
		i_slots[i].slot_index = i
		i_slots[i].slotType = SlotClass.SlotType.INVENTORY
	var h_slots = hotbar_slots.get_children()
	for i in range(h_slots.size()):
		h_slots[i].connect("gui_input", self, "slot_gui_input", [h_slots[i]])
		h_slots[i].connect("mouse_entered", self, "hovered_slot", [h_slots[i]])
		h_slots[i].connect("mouse_exited", self, "exited_slot", [h_slots[i]])
		h_slots[i].slot_index = i
		h_slots[i].slotType = SlotClass.SlotType.HOTBAR_INVENTORY


func initialize():
	PlayerInventory.InventorySlots = $InventorySlots
	show()
	$CompositeSprites.set_player_animation(Server.player_node.character, "idle_down")
	$CompositeSprites/AnimationPlayer.play("loop")
	item = null
	var i_slots = inventory_slots.get_children()
	for i in range(i_slots.size()):
		if JsonData.player_data["inventory"].has(str(i)):
			i_slots[i].initialize_item(JsonData.player_data["inventory"][str(i)][0], JsonData.player_data["inventory"][str(i)][1], JsonData.player_data["inventory"][str(i)][2])
	var h_slots = hotbar_slots.get_children()
	for i in range(h_slots.size()):
		if JsonData.player_data["hotbar"].has(str(i)):
			h_slots[i].initialize_item(JsonData.player_data["hotbar"][str(i)][0], JsonData.player_data["hotbar"][str(i)][1], JsonData.player_data["hotbar"][str(i)][2])


enum SlotType {
	HOTBAR = 0,
	INVENTORY,
	CHEST
}


func _physics_process(delta):
	if not visible:
		return
	if item and not find_parent("UserInterface").holding_item:
		get_node("../ItemDescription").show()
		get_node("../ItemDescription").item_category = JsonData.item_data[item]["ItemCategory"]
		get_node("../ItemDescription").item_name = item
		get_node("../ItemDescription").initialize()
	else:
		get_node("../ItemDescription").hide()


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
		var new_qt = int(slot.item.item_quantity / 2)
		PlayerInventory.decrease_item_quantity(slot, int(slot.item.item_quantity / 2))
		slot.item.decrease_item_quantity(int(slot.item.item_quantity / 2))
		find_parent("UserInterface").holding_item = return_holding_item(slot.item.item_name, new_qt)
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

func return_holding_item(item_name, qt):
	var inventoryItem = InventoryItem.instance()
	inventoryItem.set_item(item_name, qt, null)
	find_parent("UserInterface").add_child(inventoryItem)
	return inventoryItem

func _input(_event):
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

func left_click_empty_slot(slot):
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = null

func left_click_different_item(event: InputEvent, slot):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = temp_item

func left_click_same_item(slot):
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

func left_click_not_holding(slot):
	PlayerInventory.remove_item(slot)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

