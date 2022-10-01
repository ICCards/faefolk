extends Control

var item
var furnace_id

onready var hotbar_slots = $HotbarSlots
onready var inventory_slots = $InventorySlots
onready var furnace_slots = $FurnaceSlots
onready var ore_slot1 = $FurnaceSlots/OreSlot1
onready var ore_slot2 = $FurnaceSlots/OreSlot2
onready var fuel_slot = $FurnaceSlots/FuelSlot
onready var yield_slot1 = $FurnaceSlots/YieldSlot1
onready var yield_slot2 = $FurnaceSlots/YieldSlot2
onready var coal_yield_slot = $FurnaceSlots/CoalYieldSlot

const SlotClass = preload("res://InventoryLogic/Slot.gd")
onready var InventoryItem = preload("res://InventoryLogic/InventoryItem.tscn")

func _ready():
	furnace_id = PlayerInventory.furnace_id
	var slots_in_inventory = inventory_slots.get_children()
	var slots_in_hotbar = hotbar_slots.get_children()
	var slots_in_furnace = furnace_slots.get_children()
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
	for i in range(slots_in_furnace.size()):
		slots_in_furnace[i].connect("gui_input", self, "slot_gui_input", [slots_in_furnace[i]])
		slots_in_furnace[i].connect("mouse_entered", self, "hovered_slot", [slots_in_furnace[i]])
		slots_in_furnace[i].connect("mouse_exited", self, "exited_slot", [slots_in_furnace[i]])
		slots_in_furnace[i].slot_index = i
		slots_in_furnace[i].slotType = SlotClass.SlotType.FURNACE
	initialize()

func initialize():
	Server.player_node.destroy_placable_object()
	item = null
	show()
	initialize_hotbar()
	initialize_inventory()
	initialize_furnace()
	check_if_furnace_active()

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
	if $CookTimer.time_left == 0:
		return 
	else:
		$TimerProgress.value = (10-$CookTimer.time_left)*10


func able_to_put_into_slot(slot: SlotClass):
	var holding_item = find_parent("UserInterface").holding_item
	if holding_item == null:
		return true
	var holding_item_name = holding_item.item_name 
	if slot.slot_index == 0 and slot.name == "FuelSlot": # fuel
		return holding_item_name == "wood" or holding_item_name == "coal"
	elif (slot.slot_index == 1 or slot.slot_index == 2) and slot.name.substr(0,7) == "OreSlot": # ingredients
		return holding_item_name == "iron ore" or holding_item_name == "bronze ore" or holding_item_name == "gold ore"
	elif slot.slotType == SlotClass.SlotType.FURNACE and (slot.slot_index == 3 or slot.slot_index == 4 or slot.slot_index == 5): # yield
		return false
	return true

func _on_CookTimer_timeout():
	smelt()
	check_if_furnace_active()


func smelt():
	if ore_slot1.item:
		if ore_slot1.item.item_quantity >= 5 and valid_yield_slot(ore_slot1.item.item_name):
			remove_fuel()
			ore_slot1.item.decrease_item_quantity(5)
			PlayerInventory.decrease_item_quantity(ore_slot1, 5, furnace_id)
			add_to_yield_slot(ore_slot1.item.item_name)
			if ore_slot1.item.item_quantity == 0:
				ore_slot1.removeFromSlot()
				PlayerInventory.remove_item(ore_slot1, furnace_id)
			return
	if ore_slot2.item:
		if ore_slot2.item.item_quantity >= 5 and valid_yield_slot(ore_slot2.item.item_name):
			remove_fuel()
			ore_slot2.item.decrease_item_quantity(5)
			PlayerInventory.decrease_item_quantity(ore_slot2, 5, furnace_id)
			add_to_yield_slot(ore_slot2.item.item_name)
			if ore_slot2.item.item_quantity == 0:
				ore_slot2.removeFromSlot()
				PlayerInventory.remove_item(ore_slot2, furnace_id)
			return
			
func remove_fuel():
	if fuel_slot.item.item_name == "wood":
		fuel_slot.item.decrease_item_quantity(3)
		PlayerInventory.decrease_item_quantity(fuel_slot, 3, furnace_id)
		if fuel_slot.item.item_quantity == 0:
			fuel_slot.removeFromSlot()
			PlayerInventory.remove_item(fuel_slot, furnace_id)
		if coal_yield_slot.item:
			PlayerInventory.add_item_quantity(coal_yield_slot, 3, furnace_id)
			coal_yield_slot.item.add_item_quantity(3)
		else:
			coal_yield_slot.initialize_item("coal", 3, null)
			PlayerInventory.furnaces[furnace_id][5] = ["coal", 3, null]
	elif fuel_slot.item.item_name == "coal":
		fuel_slot.item.decrease_item_quantity(1)
		PlayerInventory.decrease_item_quantity(fuel_slot, 1, furnace_id)
		if fuel_slot.item.item_quantity == 0:
			fuel_slot.removeFromSlot()
			PlayerInventory.remove_item(fuel_slot, furnace_id)

func add_to_yield_slot(ore_name):
	var ingot_name
	match ore_name:
		"bronze ore":
			ingot_name = "bronze ingot"
		"iron ore":
			ingot_name = "iron ingot"
		"gold ore":
			ingot_name = "gold ingot"
	if yield_slot1.item:
		if yield_slot1.item.item_name == ingot_name and yield_slot1.item.item_quantity != 999:
			yield_slot1.item.add_item_quantity(1)
			PlayerInventory.add_item_quantity(yield_slot1, 1, furnace_id)
			return
	if yield_slot2.item:
		if yield_slot2.item.item_name == ingot_name and yield_slot2.item.item_quantity != 999:
			yield_slot2.item.add_item_quantity(1)
			PlayerInventory.add_item_quantity(yield_slot2, 1, furnace_id)
			return
	if not yield_slot1.item:
		yield_slot1.initialize_item(ingot_name, 1, null)
		PlayerInventory.furnaces[furnace_id][3] = [ingot_name, 1, null]
		return
	if not yield_slot2.item:
		yield_slot2.initialize_item(ingot_name, 1, null)
		PlayerInventory.furnaces[furnace_id][4] = [ingot_name, 1, null]
		return


func check_if_furnace_active():
	if valid_recipe():
		cooking_active()
	else:
		cooking_inactive()


func valid_recipe():
	if valid_fuel():
		if ore_slot1.item:
			if ore_slot1.item.item_quantity >= 5:
				if valid_yield_slot(ore_slot1.item.item_name):
					return true
		if ore_slot2.item:
			if ore_slot2.item.item_quantity >= 5:
				if valid_yield_slot(ore_slot2.item.item_name):
					return true
	return false

func valid_yield_slot(ore_name):
	var ingot_name
	match ore_name:
		"bronze ore":
			ingot_name = "bronze ingot"
		"iron ore":
			ingot_name = "iron ingot"
		"gold ore":
			ingot_name = "gold ingot"
	if yield_slot1.item:
		if yield_slot1.item.item_name == ingot_name and yield_slot1.item.item_quantity != 999:
			return true
	if yield_slot2.item:
		if yield_slot2.item.item_name == ingot_name and yield_slot2.item.item_quantity != 999:
			return true
	if not yield_slot1.item:
		return true
	if not yield_slot2.item:
		return true
	return false


func cooking_active():
	$CookTimer.start()
	$FireAnimatedSprite.playing = true
	$FireAnimatedSprite.material.set_shader_param("flash_modifier", 0)
	$FireAnimatedSprite.modulate = Color("ffffff")

func cooking_inactive():
	$CookTimer.stop()
	$TimerProgress.value = 0
	$FireAnimatedSprite.playing = false
	$FireAnimatedSprite.material.set_shader_param("flash_modifier", 1)
	$FireAnimatedSprite.modulate = Color("96ffffff")


func valid_fuel():
	if fuel_slot.item:
		if fuel_slot.item.item_name == "wood" and fuel_slot.item.item_quantity >= 3:
			return true
		elif fuel_slot.item.item_name == "coal" and fuel_slot.item.item_quantity >= 1:
			return true
	return false

func initialize_furnace():
	var slots_in_furnace = furnace_slots.get_children()
	for i in range(slots_in_furnace.size()):
		if slots_in_furnace[i].item != null:
			slots_in_furnace[i].removeFromSlot()
		if PlayerInventory.furnaces[furnace_id].has(i):
			slots_in_furnace[i].initialize_item(PlayerInventory.furnaces[furnace_id][i][0], PlayerInventory.furnaces[furnace_id][i][1], PlayerInventory.furnaces[furnace_id][i][2])
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
		elif event.button_index == BUTTON_RIGHT && event.pressed:
			if slot.item and not find_parent("UserInterface").holding_item:
				right_click_slot(slot)


func right_click_slot(slot):
	if slot.item.item_quantity > 1:
		var new_qt = slot.item.item_quantity / 2
		PlayerInventory.decrease_item_quantity(slot, slot.item.item_quantity / 2, furnace_id)
		slot.item.decrease_item_quantity(slot.item.item_quantity / 2)
		find_parent("UserInterface").holding_item = return_holding_item(slot.item.item_name, new_qt)
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
		if slot.slotType == SlotClass.SlotType.FURNACE and (slot.slot_index == 0 or slot.slot_index == 1 or slot.slot_index == 2):
			check_if_furnace_active()
		

func return_holding_item(item_name, qt):
	var inventoryItem = InventoryItem.instance()
	inventoryItem.set_item(item_name, qt, null)
	find_parent("UserInterface").add_child(inventoryItem)
	return inventoryItem


func left_click_empty_slot(slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, furnace_id)
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = null
		if slot.slotType == SlotClass.SlotType.FURNACE and (slot.slot_index == 0 or slot.slot_index == 1 or slot.slot_index == 2):
			check_if_furnace_active()

func left_click_different_item(event: InputEvent, slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot, furnace_id)
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, furnace_id)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = temp_item
		if slot.slotType == SlotClass.SlotType.FURNACE and (slot.slot_index == 0 or slot.slot_index == 1 or slot.slot_index == 2):
			check_if_furnace_active()

func left_click_same_item(slot: SlotClass):
	if able_to_put_into_slot(slot):
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= find_parent("UserInterface").holding_item.item_quantity:
			PlayerInventory.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity, furnace_id)
			slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
			find_parent("UserInterface").holding_item.queue_free()
			find_parent("UserInterface").holding_item = null
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add, furnace_id)
			slot.item.add_item_quantity(able_to_add)
			find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)
		if slot.slotType == SlotClass.SlotType.FURNACE and (slot.slot_index == 0 or slot.slot_index == 1 or slot.slot_index == 2):
			check_if_furnace_active()

func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot, furnace_id)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
	if slot.slotType == SlotClass.SlotType.FURNACE and (slot.slot_index == 0 or slot.slot_index == 1 or slot.slot_index == 2):
		check_if_furnace_active()

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
	get_parent().close_furnace()

