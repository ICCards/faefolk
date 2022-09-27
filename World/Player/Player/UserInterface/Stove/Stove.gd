extends Control

var object_tiles
var item
var stove_id = PlayerInventory.stove_id.substr(2,-1)
var level = PlayerInventory.stove_id.substr(0,1)
var is_stove_active
var ingredients = []

onready var hotbar_slots = $HotbarSlots
onready var inventory_slots = $InventorySlots
onready var stove_slots = $StoveSlots

const SlotClass = preload("res://InventoryLogic/Slot.gd")
onready var InventoryItem = preload("res://InventoryLogic/InventoryItem.tscn")

func _ready():
	var slots_in_inventory = inventory_slots.get_children()
	var slots_in_hotbar = hotbar_slots.get_children()
	var slots_in_stove = stove_slots.get_children()
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
	for i in range(slots_in_stove.size()):
		slots_in_stove[i].connect("gui_input", self, "slot_gui_input", [slots_in_stove[i]])
		slots_in_stove[i].connect("mouse_entered", self, "hovered_slot", [slots_in_stove[i]])
		slots_in_stove[i].connect("mouse_exited", self, "exited_slot", [slots_in_stove[i]])
		slots_in_stove[i].slot_index = i
		slots_in_stove[i].slotType = SlotClass.SlotType.STOVE
	initialize()



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

func initialize():
	Server.player_node.destroy_placable_object()
	show()
	$Title.text = "Stove #" + level[0].to_upper() + level.substr(1,-1) + ":" 
	initialize_hotbar()
	initialize_inventory()
	initialize_stove_data()
	check_valid_recipe()
	
	
func check_valid_recipe():
#	if not $StoveSlots/FuelSlot.item:
#		return false
	ingredients = []
	if $StoveSlots/Ingredient1.item:
		ingredients.append([$StoveSlots/Ingredient1.item.item_name, $StoveSlots/Ingredient1.item.item_quantity])
	if $StoveSlots/Ingredient2.item:
		ingredients.append([$StoveSlots/Ingredient2.item.item_name, $StoveSlots/Ingredient2.item.item_quantity])
	if $StoveSlots/Ingredient3.item:
		ingredients.append([$StoveSlots/Ingredient3.item.item_name, $StoveSlots/Ingredient3.item.item_quantity])
#	for item in JsonData.item_data:
#		if JsonData.item_data[item]["ItemCategory"] == "Food":
#			#for ingredient in JsonData.item_data[item]["Ingredients"]:
#			for input in ingredients:
#				if input[0] == ingredients
	print(ingredients)

func initialize_stove_data():
	var slots_in_stove = stove_slots.get_children()
	for i in range(slots_in_stove.size()):
		if slots_in_stove[i].item != null:
			slots_in_stove[i].removeFromSlot()
		if PlayerInventory.stoves[stove_id].has(i):
			slots_in_stove[i].initialize_item(PlayerInventory.stoves[stove_id][i][0], PlayerInventory.stoves[stove_id][i][1], PlayerInventory.stoves[stove_id][i][2])
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

func able_to_put_into_slot(slot: SlotClass):
	var holding_item = find_parent("UserInterface").holding_item
	if holding_item == null:
		return true
	var holding_item_name = holding_item.item_name 
	var holding_item_category = JsonData.item_data[holding_item_name]["ItemCategory"]
	if slot.slot_index == 0 and slot.name == "FuelSlot": # fuel
		return holding_item_name == "wood"
	elif (slot.slot_index == 1 or slot.slot_index == 2 or slot.slot_index == 3) and slot.name.substr(0,10) == "Ingredient": # ingredients
		return holding_item_category == "Crop" or holding_item_category == "Fish" or holding_item_category == "Food"
	elif slot.slotType == SlotClass.SlotType.STOVE and slot.slot_index == 4: # yield
		return false
	return true


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
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, stove_id)
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = null
		check_valid_recipe()

func left_click_different_item(event: InputEvent, slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot, stove_id)
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, stove_id)
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
			PlayerInventory.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity, stove_id)
			slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
			find_parent("UserInterface").holding_item.queue_free()
			find_parent("UserInterface").holding_item = null
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add, stove_id)
			slot.item.add_item_quantity(able_to_add)
			find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot, stove_id)
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

func _on_ExitButton_pressed():
	get_parent().close_stove()

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
