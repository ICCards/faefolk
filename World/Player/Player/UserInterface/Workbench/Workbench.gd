extends Control

var crafting_item
var item

onready var hotbar_slots = $HotbarSlots
onready var inventory_slots = $InventorySlots

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


func _physics_process(delta):
	if item and not find_parent("UserInterface").holding_item:
		$ItemDescription.show()
		$ItemDescription.item_category = JsonData.item_data[item]["ItemCategory"]
		$ItemDescription.item_name = item
		$ItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
		$ItemDescription.initialize()
	else:
		$ItemDescription.hide()
	if crafting_item and not find_parent("UserInterface").holding_item:
		$CraftingItemDescription.show()
		$CraftingItemDescription.item_name = crafting_item
		$CraftingItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
		$CraftingItemDescription.initialize()
	else:
		$CraftingItemDescription.hide()


func entered_item_area(item_name):
	crafting_item = item_name
	if $Page1.visible:
		$Tween.interpolate_property($Page1.get_node(item_name), "rect_scale",
			$Page1.get_node(item_name).rect_scale, Vector2(1.1, 1.1), 0.075,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		$Tween.interpolate_property($Page2.get_node(item_name), "rect_scale",
			$Page2.get_node(item_name).rect_scale, Vector2(1.1, 1.1), 0.075,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()

func exited_item_area(item_name):
	crafting_item = null
	if $Page1.visible:
		if $Page1.has_node(item_name):
			$Tween.interpolate_property($Page1.get_node(item_name), "rect_scale",
				$Page1.get_node(item_name).rect_scale, Vector2(1.0, 1.0), 0.075,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
	else:
		if $Page2.has_node(item_name):
			$Tween.interpolate_property($Page2.get_node(item_name), "rect_scale",
			$Page2.get_node(item_name).rect_scale, Vector2(1.0, 1.0), 0.075,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()


func craft(item_name):
	if not get_parent().holding_item and PlayerInventory.isSufficientMaterialToCraft(item_name):
		find_parent("UserInterface").holding_item = return_crafted_item(item_name)
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
		PlayerInventory.craft_item(item_name)
		initialize()

func return_crafted_item(item_name):
	var inventoryItem = InventoryItem.instance()
	print("HEALTH " + str(Stats.return_max_tool_health(item_name)))
	inventoryItem.set_item(item_name, 1, Stats.return_max_tool_health(item_name))
	find_parent("UserInterface").add_child(inventoryItem)
	return inventoryItem

func _on_DownButton_pressed():
	$Page1.hide()
	$Page2.show()
	$Page2.initialize()
	$DownButton.hide()
	$UpButton.show()
	

func _on_UpButton_pressed():
	$Page1.show()
	$Page2.hide()
	$Page1.initialize()
	$DownButton.show()
	$UpButton.hide()

func initialize():
	item = null
	crafting_item = null
	show()
	$Page1.initialize()
	$Page2.initialize()
	initialize_hotbar()
	initialize_inventory()

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
	PlayerInventory.remove_item(slot)
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
	get_parent().toggle_workbench()