extends Control

onready var InventoryItem = preload("res://InventoryLogic/InventoryItem.tscn")
const SlotClass = preload("res://InventoryLogic/Slot.gd")
onready var inventory_slots = $InventorySlots
onready var hotbar_slots = $HotbarSlots
var item

func _ready():
	$NameOfSong.text = Sounds.demo_names[Sounds.index]
	Sounds.connect("song_finished", self, "set_current_song")
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

func set_current_song():
	$NameOfSong.text = Sounds.demo_names[Sounds.index]

func initialize():
	PlayerInventory.InventorySlots = $InventorySlots
	show()
	$CompositeSprites.set_player_animation(Server.player_node.character, "idle_down")
	$CompositeSprites/AnimationPlayer.play("loop")
	item = null
	var i_slots = inventory_slots.get_children()
	for i in range(i_slots.size()):
		if i_slots[i].item != null:
			i_slots[i].removeFromSlot()
		if PlayerInventory.inventory.has(i):
			i_slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1], PlayerInventory.inventory[i][2])
	var h_slots = hotbar_slots.get_children()
	for i in range(h_slots.size()):
		if h_slots[i].item != null:
			h_slots[i].removeFromSlot()
		if PlayerInventory.hotbar.has(i):
			h_slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1], PlayerInventory.hotbar[i][2])


enum SlotType {
	HOTBAR = 0,
	INVENTORY,
	CHEST
}


func _physics_process(delta):
	if not visible:
		return
	if item and not find_parent("UserInterface").holding_item:
		$ItemDescription.show()
		$ItemDescription.item_category = JsonData.item_data[item]["ItemCategory"]
		$ItemDescription.item_name = item
		$ItemDescription.initialize()
	else:
		$ItemDescription.hide()

func initialize_inventory_menu():
	item = null
	var i_slots = inventory_slots.get_children()
	for i in range(i_slots.size()):
		if i_slots[i].item != null:
			i_slots[i].removeFromSlot()
		if PlayerInventory.inventory.has(i):
			i_slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1], PlayerInventory.inventory[i][2])
	var h_slots = hotbar_slots.get_children()
	for i in range(h_slots.size()):
		if h_slots[i].item != null:
			h_slots[i].removeFromSlot()
		if PlayerInventory.hotbar.has(i):
			h_slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1], PlayerInventory.hotbar[i][2])


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





func _on_SkipSong_pressed():
	Sounds.index += 1
	if Sounds.index == Sounds.demo_names.size():
		Sounds.index = 0
	$NameOfSong.text = Sounds.demo_names[Sounds.index]
	Sounds.emit_signal("song_skipped")
