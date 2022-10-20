extends Control

onready var inventory_slots = $InventorySlots
onready var hotbar_slots = $HotbarSlots
const SlotClass = preload("res://InventoryLogic/Slot.gd")
var crafting_item = null
var item = null
var page = 1
onready var InventoryItem = preload("res://InventoryLogic/InventoryItem.tscn")

func _ready():
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
	crafting_item = null
	item = null
	show()
	page = 1
	reset_hover_effect()
	initialize_crafting()
	set_current_page()


func set_current_page():
	match page:
		1:
			$Page1.show()
			$Page2.hide()
			$Page3.hide()
			$Page4.hide()
			$Page5.hide()
			$Page6.hide()
			$Page7.hide()
			$Page8.hide()
			$UpButton.hide()
			$DownButton.show()
		2:
			$Page1.hide()
			$Page2.show()
			$Page3.hide()
			$Page4.hide()
			$Page5.hide()
			$Page6.hide()
			$Page7.hide()
			$Page8.hide()
			$UpButton.show()
			$DownButton.show()
		3:
			$Page1.hide()
			$Page2.hide()
			$Page3.show()
			$Page4.hide()
			$Page5.hide()
			$Page6.hide()
			$Page7.hide()
			$Page8.hide()
			$UpButton.show()
			$DownButton.show()
		4:
			$Page1.hide()
			$Page2.hide()
			$Page3.hide()
			$Page4.show()
			$Page5.hide()
			$Page6.hide()
			$Page7.hide()
			$Page8.hide()
			$UpButton.show()
			$DownButton.show()
		5:
			$Page1.hide()
			$Page2.hide()
			$Page3.hide()
			$Page4.hide()
			$Page5.show()
			$Page6.hide()
			$Page7.hide()
			$Page8.hide()
			$UpButton.show()
			$DownButton.show()
		6:
			$Page1.hide()
			$Page2.hide()
			$Page3.hide()
			$Page4.hide()
			$Page5.hide()
			$Page6.show()
			$Page7.hide()
			$Page8.hide()
			$UpButton.show()
			$DownButton.show()
		7:
			$Page1.hide()
			$Page2.hide()
			$Page3.hide()
			$Page4.hide()
			$Page5.hide()
			$Page6.hide()
			$Page7.show()
			$Page8.hide()
			$UpButton.show()
			$DownButton.show()
		8:
			$Page1.hide()
			$Page2.hide()
			$Page3.hide()
			$Page4.hide()
			$Page5.hide()
			$Page6.hide()
			$Page7.hide()
			$Page8.show()
			$UpButton.show()
			$DownButton.hide()


func intialize_slots():
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


func _on_UpButton_pressed():
	if page != 1:
		page -= 1
		set_current_page()
		initialize_crafting()

func _on_DownButton_pressed():
	if page != 8:
		page += 1
		set_current_page()
		initialize_crafting()


func reset_hover_effect():
	for item in $Page1.get_children():
		item = str(item.name)
		if item == "blueprint" or item == "hammer" or item == "wood sword" or item == "wood axe" or item == "wood pickaxe" or item == "wood hoe":
			$Page1.get_node(item).rect_scale = Vector2(8,8)
		else:
			$Page1.get_node(item).rect_scale = Vector2(4,4)
	for item in $Page2.get_children():
		item = str(item.name)
		$Page2.get_node(item).rect_scale = Vector2(4,4)
	for item in $Page3.get_children():
		item = str(item.name)
		$Page3.get_node(item).rect_scale = Vector2(4,4)
	for item in $Page4.get_children():
		item = str(item.name)
		$Page4.get_node(item).rect_scale = Vector2(4,4)
	for item in $Page5.get_children():
		item = str(item.name)
		$Page5.get_node(item).rect_scale = Vector2(4,4)
	for item in $Page6.get_children():
		item = str(item.name)
		$Page6.get_node(item).rect_scale = Vector2(4,4)
	for item in $Page7.get_children():
		item = str(item.name)
		$Page7.get_node(item).rect_scale = Vector2(4,4)
	for item in $Page8.get_children():
		item = str(item.name)
		$Page8.get_node(item).rect_scale = Vector2(4,4)


func initialize_crafting():
	PlayerInventory.HotbarSlots = $HotbarSlots
	PlayerInventory.InventorySlots = $InventorySlots
	intialize_slots()
	if page == 1:
		for item in $Page1.get_children():
			if PlayerInventory.isSufficientMaterialToCraft(str(item.name)):
				$Page1.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page1.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 2:
		for item in $Page2.get_children():
			if PlayerInventory.isSufficientMaterialToCraft(str(item.name)):
				$Page2.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page2.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 3:
		for item in $Page3.get_children():
			if PlayerInventory.isSufficientMaterialToCraft(str(item.name)):
				$Page3.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page3.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 4:
		for item in $Page4.get_children():
			if PlayerInventory.isSufficientMaterialToCraft(str(item.name)):
				$Page4.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page4.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 5:
		for item in $Page5.get_children():
			if PlayerInventory.isSufficientMaterialToCraft(str(item.name)):
				$Page5.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page5.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 6:
		for item in $Page6.get_children():
			if PlayerInventory.isSufficientMaterialToCraft(str(item.name)):
				$Page6.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page6.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 7:
		for item in $Page7.get_children():
			if PlayerInventory.isSufficientMaterialToCraft(str(item.name)):
				$Page7.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page7.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 8:
		for item in $Page8.get_children():
			if PlayerInventory.isSufficientMaterialToCraft(str(item.name)):
				$Page8.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page8.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
 

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
	if crafting_item and not find_parent("UserInterface").holding_item:
		$CraftingItemDescription.visible = true
		$CraftingItemDescription.item_name = crafting_item
		$CraftingItemDescription.position = get_local_mouse_position() + Vector2(55 , 75)
		$CraftingItemDescription.initialize()
	else:
		$CraftingItemDescription.visible = false

func entered_crafting_area(_item):
	yield(get_tree(), "idle_frame")
	item = null
	crafting_item = _item
	if crafting_item == "blueprint" or crafting_item == "hammer" or crafting_item == "wood sword" or crafting_item == "wood axe" or crafting_item == "wood pickaxe" or crafting_item == "wood hoe":
		$Tween.interpolate_property(get_node("Page" + str(page) + "/" + crafting_item), "rect_scale",
			get_node("Page" + str(page) + "/" + crafting_item).rect_scale, Vector2(8.4, 8.4), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		$Tween.interpolate_property(get_node("Page" + str(page) + "/" + crafting_item), "rect_scale",
			get_node("Page" + str(page) + "/" + crafting_item).rect_scale, Vector2(4.2, 4.2), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
	
func exited_crafting_area(_item):
	crafting_item = null
	if has_node("Page" + str(page) + "/" + _item):
		if _item == "blueprint" or _item == "hammer" or _item == "wood sword" or _item == "wood axe" or _item == "wood pickaxe" or _item == "wood hoe":
			$Tween.interpolate_property(get_node("Page" + str(page) + "/" + _item), "rect_scale",
				get_node("Page" + str(page) + "/" + _item).rect_scale, Vector2(8, 8), 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
		else:
			$Tween.interpolate_property(get_node("Page" + str(page) + "/" + _item), "rect_scale",
				get_node("Page" + str(page) + "/" + _item).rect_scale, Vector2(4, 4), 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()


func play_craft_sound():
	pass
#	$SoundEffects.stream = Sounds.button_select
#	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
#	$SoundEffects.play()
	
func play_error_sound():
	$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/ES_Error Tone Chime 6 - SFX Producer.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()


func return_crafted_item(item_name):
	var crafted = InventoryItem.instance()
	crafted.set_item(item_name, 1, Stats.return_max_tool_health(item_name))
	find_parent("UserInterface").add_child(crafted)
	return crafted


func craftable_item_pressed(item_name):
	if PlayerInventory.isSufficientMaterialToCraft(item_name) and not find_parent("UserInterface").holding_item:
		craft(item_name)
	elif find_parent("UserInterface").holding_item:
		if find_parent("UserInterface").holding_item.item_name == item_name and PlayerInventory.isSufficientMaterialToCraft(item_name) and JsonData.item_data[item_name]["StackSize"] != 1:
			PlayerInventory.craft_item(item_name)
			find_parent("UserInterface").holding_item.add_item_quantity(1)
			initialize_crafting()
	else:
		play_error_sound()
	
func craft(item_name):
	play_craft_sound()
	find_parent("UserInterface").holding_item = return_crafted_item(item_name)
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
	PlayerInventory.craft_item(item_name)
	initialize_crafting()


func hovered_slot(slot: SlotClass):
	if slot.item and not find_parent("UserInterface").holding_item:
		crafting_item = null
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


