extends Control

var id
var level

var item
var ingredients = []

onready var hotbar_slots = $HotbarSlots
onready var inventory_slots = $InventorySlots
onready var stove_slots = $StoveSlots
onready var fuel_slot = $StoveSlots/FuelSlot
onready var ingredient_slot1 = $StoveSlots/Ingredient1
onready var ingredient_slot2 = $StoveSlots/Ingredient2
onready var ingredient_slot3 = $StoveSlots/Ingredient3
onready var yield_slot1 = $StoveSlots/YieldSlot1
onready var yield_slot2 = $StoveSlots/YieldSlot2
onready var coal_yield_slot = $StoveSlots/CoalYieldSlot
var current_cooking_item


onready var SlotClass = load("res://InventoryLogic/Slot.gd")
onready var InventoryItem = load("res://InventoryLogic/InventoryItem.tscn")

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
	if $CookTimer.time_left == 0:
		return 
	else:
		$TimerProgress.value = (10-$CookTimer.time_left)*10

func initialize():
	Server.player_node.destroy_placable_object()
	show()
	$Title.text = "Stove #" + str(level) + ":" 
	initialize_hotbar()
	initialize_inventory()
	initialize_stove_data()
	initialize_locked_slots()
	
	
func initialize_locked_slots():
	var slots_in_stove = stove_slots.get_children()
	if level == "1":
		$StoveSlots/Ingredient2/LockSlot.show()
		$StoveSlots/Ingredient3/LockSlot.show()
		for i in range(slots_in_stove.size()):
			if i != 2 and i != 3:
				slots_in_stove[i].connect("gui_input", self, "slot_gui_input", [slots_in_stove[i]])
				slots_in_stove[i].connect("mouse_entered", self, "hovered_slot", [slots_in_stove[i]])
				slots_in_stove[i].connect("mouse_exited", self, "exited_slot", [slots_in_stove[i]])
			slots_in_stove[i].slot_index = i
			slots_in_stove[i].slotType = SlotClass.SlotType.STOVE
	elif level == "2":
		$StoveSlots/Ingredient3/LockSlot.show()
		for i in range(slots_in_stove.size()):
			if i != 3:
				slots_in_stove[i].connect("gui_input", self, "slot_gui_input", [slots_in_stove[i]])
				slots_in_stove[i].connect("mouse_entered", self, "hovered_slot", [slots_in_stove[i]])
				slots_in_stove[i].connect("mouse_exited", self, "exited_slot", [slots_in_stove[i]])
			slots_in_stove[i].slot_index = i
			slots_in_stove[i].slotType = SlotClass.SlotType.STOVE
	else:
		for i in range(slots_in_stove.size()):
			slots_in_stove[i].connect("gui_input", self, "slot_gui_input", [slots_in_stove[i]])
			slots_in_stove[i].connect("mouse_entered", self, "hovered_slot", [slots_in_stove[i]])
			slots_in_stove[i].connect("mouse_exited", self, "exited_slot", [slots_in_stove[i]])
			slots_in_stove[i].slot_index = i
			slots_in_stove[i].slotType = SlotClass.SlotType.STOVE
	
	
func check_valid_recipe():
	var new_ingredients = []
	if ingredient_slot1.item:
		new_ingredients.append([ingredient_slot1.item.item_name, ingredient_slot1.item.item_quantity])
	if ingredient_slot2.item:
		new_ingredients.append([ingredient_slot2.item.item_name, ingredient_slot2.item.item_quantity])
	if ingredient_slot3.item:
		new_ingredients.append([ingredient_slot3.item.item_name, ingredient_slot3.item.item_quantity])
	if ingredients != new_ingredients:
		ingredients = new_ingredients
		if ingredients.size() == 1:
			if check_1_ingredient_recipe():
				cooking_active()
			else:
				cooking_inactive()
		elif ingredients.size() == 2:
			if check_2_ingredient_recipe():
				cooking_active()
			else:
				cooking_inactive()
		elif ingredients.size() == 3:
			if check_3_ingredient_recipe():
				cooking_active()
			else:
				cooking_inactive()
		else:
			cooking_inactive()
	elif not valid_fuel():
		cooking_inactive()


func cooking_active():
	$CookTimer.start()
	$FireAnimatedSprite.playing = true
	$FireAnimatedSprite.material.set_shader_param("flash_modifier", 0)
	$FireAnimatedSprite.modulate = Color("ffffff")

func cooking_inactive():
	ingredients = []
	$CookTimer.stop()
	$TimerProgress.value = 0
	current_cooking_item = null
	$FireAnimatedSprite.playing = false
	$FireAnimatedSprite.material.set_shader_param("flash_modifier", 1)
	$FireAnimatedSprite.modulate = Color("96ffffff")



func _on_CookTimer_timeout():
	if current_cooking_item and PlayerInventory.stoves.has(id):
		add_to_yield_slot()
		remove_ingredients()
		remove_fuel()
		check_valid_recipe()


func remove_fuel():
	if fuel_slot.item.item_name == "wood":
		fuel_slot.item.decrease_item_quantity(3)
		PlayerInventory.decrease_item_quantity(fuel_slot, 3, id)
		if fuel_slot.item.item_quantity == 0:
			fuel_slot.removeFromSlot()
			PlayerInventory.remove_item(fuel_slot, id)
		if coal_yield_slot.item:
			PlayerInventory.add_item_quantity(coal_yield_slot, 3, id)
			coal_yield_slot.item.add_item_quantity(3)
		else:
			coal_yield_slot.initialize_item("coal", 3, null)
			PlayerInventory.stoves[id][6] = ["coal", 3, null]
	elif fuel_slot.item.item_name == "coal":
		fuel_slot.item.decrease_item_quantity(1)
		PlayerInventory.decrease_item_quantity(fuel_slot, 1, id)
		if fuel_slot.item.item_quantity == 0:
			fuel_slot.removeFromSlot()
			PlayerInventory.remove_item(fuel_slot, id)

func remove_ingredients():
	for ingredient in JsonData.item_data[current_cooking_item]["Ingredients"]:
		if ingredient_slot1.item:
			if ingredient[0] == ingredient_slot1.item.item_name:
				PlayerInventory.decrease_item_quantity(ingredient_slot1, ingredient[1], id)
				ingredient_slot1.item.decrease_item_quantity(ingredient[1])
				if ingredient_slot1.item.item_quantity == 0:
					ingredient_slot1.removeFromSlot()
					PlayerInventory.remove_item(ingredient_slot1, id)
		if ingredient_slot2.item:
			if ingredient[0] == ingredient_slot2.item.item_name:
				PlayerInventory.decrease_item_quantity(ingredient_slot2, ingredient[1], id)
				ingredient_slot2.item.decrease_item_quantity(ingredient[1])
				if ingredient_slot2.item.item_quantity == 0:
					ingredient_slot2.removeFromSlot()
					PlayerInventory.remove_item(ingredient_slot2, id)
		if ingredient_slot3.item:
			if ingredient[0] == ingredient_slot3.item.item_name:
				PlayerInventory.decrease_item_quantity(ingredient_slot3, ingredient[1], id)
				ingredient_slot3.item.decrease_item_quantity(ingredient[1])
				if ingredient_slot3.item.item_quantity == 0:
					ingredient_slot3.removeFromSlot()
					PlayerInventory.remove_item(ingredient_slot3, id)

func add_to_yield_slot():
	CollectionsData.food[current_cooking_item] += 1
	if not yield_slot1.item:
		yield_slot1.initialize_item(current_cooking_item, 1, null)
		PlayerInventory.stoves[id][4] = [current_cooking_item, 1, null]
	elif not yield_slot1.item.item_quantity == 999:
		PlayerInventory.add_item_quantity(yield_slot1, 1, id)
		yield_slot1.item.add_item_quantity(1)
	elif not yield_slot2.item:
		yield_slot2.initialize_item(current_cooking_item, 1, null)
		PlayerInventory.stoves[id][5] = [current_cooking_item, 1, null]
	else:
		PlayerInventory.add_item_quantity(yield_slot2, 1, id)
		yield_slot2.item.add_item_quantity(1)


func check_valid_yield_slot_and_fuel(new_item):
	if valid_fuel():
		if not yield_slot1.item: # empty yield slot
			current_cooking_item = new_item
			return true
		elif yield_slot1.item.item_name == new_item: # yield slot same as recipe
			current_cooking_item = new_item
			return true
		elif not yield_slot2.item:
			current_cooking_item = new_item
			return true
		elif yield_slot2.item.item_name == new_item: # yield slot same as recipe
			current_cooking_item = new_item
			return true
	return false


func valid_fuel():
	if fuel_slot.item:
		if fuel_slot.item.item_name == "wood" and fuel_slot.item.item_quantity >= 3:
			return true
		elif fuel_slot.item.item_name == "coal" and fuel_slot.item.item_quantity >= 1:
			return true
	return false

func check_1_ingredient_recipe():
	for item in JsonData.item_data:
		if JsonData.item_data[item]["ItemCategory"] == "Food" and JsonData.item_data[item]["Ingredients"]:
			if JsonData.item_data[item]["Ingredients"].size() == 1:
				if ingredients[0][0] == JsonData.item_data[item]["Ingredients"][0][0] and ingredients[0][1] >= JsonData.item_data[item]["Ingredients"][0][1]: # checks name and sufficient ingredients
					return check_valid_yield_slot_and_fuel(item)
	return false

func check_2_ingredient_recipe():
	for item in JsonData.item_data:
		if JsonData.item_data[item]["ItemCategory"] == "Food" and JsonData.item_data[item]["Ingredients"]:
			if JsonData.item_data[item]["Ingredients"].size() == 2:
				var recipe = JsonData.item_data[item]["Ingredients"]
				if ingredients[0][0] == recipe[0][0] and ingredients[1][0] == recipe[1][0]:
					if ingredients[0][1] >= recipe[0][1] and ingredients[1][1] >= recipe[1][1]: 
						return check_valid_yield_slot_and_fuel(item)
				elif ingredients[0][0] == recipe[1][0] and ingredients[1][0] == recipe[0][0]:
					if ingredients[0][1] >= recipe[1][1] and ingredients[1][1] >= recipe[0][1]:
						return check_valid_yield_slot_and_fuel(item)
	return false
	
func check_3_ingredient_recipe():
	for item in JsonData.item_data:
		if JsonData.item_data[item]["ItemCategory"] == "Food" and JsonData.item_data[item]["Ingredients"]:
			if JsonData.item_data[item]["Ingredients"].size() == 3:
				var recipe = JsonData.item_data[item]["Ingredients"]
				if ingredients[0][0] == recipe[0][0] and ingredients[1][0] == recipe[1][0] and ingredients[2][0] == recipe[2][0]:
					if ingredients[0][1] >= recipe[0][1] and ingredients[1][1] >= recipe[1][1] and ingredients[2][1] >= recipe[2][1]: 
						return check_valid_yield_slot_and_fuel(item)
				elif ingredients[0][0] == recipe[0][0] and ingredients[1][0] == recipe[2][0] and ingredients[2][0] == recipe[1][0]:
					if ingredients[0][1] >= recipe[0][1] and ingredients[1][1] >= recipe[2][1] and ingredients[2][1] >= recipe[1][1]: 
						return check_valid_yield_slot_and_fuel(item)
				elif ingredients[0][0] == recipe[1][0] and ingredients[1][0] == recipe[0][0] and ingredients[2][0] == recipe[2][0]:
					if ingredients[0][1] >= recipe[1][1] and ingredients[1][1] >= recipe[0][1] and ingredients[2][1] >= recipe[2][1]: 
						return check_valid_yield_slot_and_fuel(item)
				elif ingredients[0][0] == recipe[1][0] and ingredients[1][0] == recipe[2][0] and ingredients[2][0] == recipe[0][0]:
					if ingredients[0][1] >= recipe[1][1] and ingredients[1][1] >= recipe[2][1] and ingredients[2][1] >= recipe[0][1]: 
						return check_valid_yield_slot_and_fuel(item)
				elif ingredients[0][0] == recipe[2][0] and ingredients[1][0] == recipe[1][0] and ingredients[2][0] == recipe[0][0]:
					if ingredients[0][1] >= recipe[2][1] and ingredients[1][1] >= recipe[1][1] and ingredients[2][1] >= recipe[0][1]: 
						return check_valid_yield_slot_and_fuel(item)
				elif ingredients[0][0] == recipe[2][0] and ingredients[1][0] == recipe[0][0] and ingredients[2][0] == recipe[1][0]:
					if ingredients[0][1] >= recipe[2][1] and ingredients[1][1] >= recipe[0][1] and ingredients[2][1] >= recipe[1][1]: 
						return check_valid_yield_slot_and_fuel(item)
	return false

func initialize_stove_data():
	var slots_in_stove = stove_slots.get_children()
	for i in range(slots_in_stove.size()):
		if slots_in_stove[i].item != null:
			slots_in_stove[i].removeFromSlot()
		if PlayerInventory.stoves[id].has(i):
			slots_in_stove[i].initialize_item(PlayerInventory.stoves[id][i][0], PlayerInventory.stoves[id][i][1], PlayerInventory.stoves[id][i][2])

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

func hovered_slot(slot):
	if slot.item:
		slot.item.hover_item()
		item = slot.item.item_name

func exited_slot(slot):
	item = null
	if slot.item:
		slot.item.exit_item()

func able_to_put_into_slot(slot):
	var holding_item = find_parent("UserInterface").holding_item
	if holding_item == null:
		return true
	var holding_item_name = holding_item.item_name 
	var holding_item_category = JsonData.item_data[holding_item_name]["ItemCategory"]
	if slot.slot_index == 0 and slot.name == "FuelSlot": # fuel
		return holding_item_name == "wood" or holding_item_name == "coal"
	elif (slot.slot_index == 1 or slot.slot_index == 2 or slot.slot_index == 3) and slot.name.substr(0,10) == "Ingredient": # ingredients
		return holding_item_category == "Crop" or holding_item_category == "Fish" or holding_item_category == "Food"
	elif slot.slotType == SlotClass.SlotType.STOVE and (slot.slot_index == 4 or slot.slot_index == 5 or slot.slot_index == 6): # yield
		return false
	return true
	
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
		PlayerInventory.decrease_item_quantity(slot, int(slot.item.item_quantity / 2), id)
		slot.item.decrease_item_quantity(int(slot.item.item_quantity / 2))
		find_parent("UserInterface").holding_item = return_holding_item(slot.item.item_name, new_qt)
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
		check_valid_recipe()


func return_holding_item(item_name, qt):
	var inventoryItem = InventoryItem.instance()
	inventoryItem.set_item(item_name, qt, null)
	find_parent("UserInterface").add_child(inventoryItem)
	return inventoryItem


func left_click_empty_slot(slot):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, id)
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = null
		check_valid_recipe()

func left_click_different_item(event: InputEvent, slot):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot, id)
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot, id)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = temp_item
		check_valid_recipe()

func left_click_same_item(slot):
	if able_to_put_into_slot(slot):
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= find_parent("UserInterface").holding_item.item_quantity:
			PlayerInventory.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity, id)
			slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
			find_parent("UserInterface").holding_item.queue_free()
			find_parent("UserInterface").holding_item = null
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add, id)
			slot.item.add_item_quantity(able_to_add)
			find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)
		check_valid_recipe()

func left_click_not_holding(slot):
	PlayerInventory.remove_item(slot, id)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
	check_valid_recipe()


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

#func _unhandled_input(event):
#	if event.is_action_pressed("action"):
#		get_parent().close_stove(id)

func _on_ExitButton_pressed():
	get_parent().close_stove(id)

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

