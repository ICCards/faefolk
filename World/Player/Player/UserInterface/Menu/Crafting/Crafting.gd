extends Control

var hovered_item = null
var crafting_item = null
var page = 1
var InventoryItem = preload("res://InventoryLogic/InventoryItem.tscn")

func initialize():
	crafting_item = null
	hovered_item = null
	show()
	page = 1
	reset_hover_effect()
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
	PlayerData.HotbarSlots = $HotbarInventorySlots
	PlayerData.InventorySlots = $InventorySlots
	$InventorySlots.initialize_slots()
	$HotbarInventorySlots.initialize_slots()
	if page == 1:
		for item in $Page1.get_children():
			if PlayerData.isSufficientMaterialToCraft(str(item.name)):
				$Page1.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page1.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 2:
		for item in $Page2.get_children():
			if PlayerData.isSufficientMaterialToCraft(str(item.name)):
				$Page2.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page2.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 3:
		for item in $Page3.get_children():
			if PlayerData.isSufficientMaterialToCraft(str(item.name)):
				$Page3.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page3.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 4:
		for item in $Page4.get_children():
			if PlayerData.isSufficientMaterialToCraft(str(item.name)):
				$Page4.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page4.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 5:
		for item in $Page5.get_children():
			if PlayerData.isSufficientMaterialToCraft(str(item.name)):
				$Page5.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page5.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 6:
		for item in $Page6.get_children():
			if PlayerData.isSufficientMaterialToCraft(str(item.name)):
				$Page6.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page6.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 7:
		for item in $Page7.get_children():
			if PlayerData.isSufficientMaterialToCraft(str(item.name)):
				$Page7.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page7.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
	elif page == 8:
		for item in $Page8.get_children():
			if PlayerData.isSufficientMaterialToCraft(str(item.name)):
				$Page8.get_node(str(item.name)).modulate = Color(1, 1, 1, 1)
			else:
				$Page8.get_node(str(item.name)).modulate = Color(1, 1, 1, 0.4)
 

func _physics_process(delta):
	if not visible:
		return
	if hovered_item and not find_parent("UserInterface").holding_item:
		get_node("../ItemDescription").show()
		get_node("../ItemDescription").item_category = JsonData.item_data[hovered_item]["ItemCategory"]
		get_node("../ItemDescription").item_name = hovered_item
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
	hovered_item = null
	crafting_item = _item
	if crafting_item == "blueprint" or crafting_item == "hammer" or crafting_item == "wood sword" or crafting_item == "wood axe" or crafting_item == "wood pickaxe" or crafting_item == "wood hoe":
		$Tween.interpolate_property(get_node("CraftingMenu/Items/" + crafting_item), "rect_scale",
			get_node("CraftingMenu/Items/" + crafting_item).rect_scale, Vector2(8.4, 8.4), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		$Tween.interpolate_property(get_node("CraftingMenu/Items/" + crafting_item), "rect_scale",
			get_node("CraftingMenu/Items/" + crafting_item).rect_scale, Vector2(4.2, 4.2), 0.1,
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
	$SoundEffects.stream = load("res://Assets/Sound/Sound effects/Farming/ES_Error Tone Chime 6 - SFX Producer.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -20)
	$SoundEffects.play()


func return_crafted_item(item_name):
	var crafted = InventoryItem.instance()
	crafted.set_item(item_name, 1, Stats.return_max_tool_health(item_name))
	find_parent("UserInterface").add_child(crafted)
	return crafted


func craftable_item_pressed(item_name):
	if PlayerData.isSufficientMaterialToCraft(item_name) and not find_parent("UserInterface").holding_item:
		craft(item_name)
	elif find_parent("UserInterface").holding_item:
		if find_parent("UserInterface").holding_item.item_name == item_name and PlayerData.isSufficientMaterialToCraft(item_name) and JsonData.item_data[item_name]["StackSize"] != 1:
			PlayerData.craft_item(item_name)
			find_parent("UserInterface").holding_item.add_item_quantity(1)
			initialize_crafting()
	else:
		play_error_sound()
	
func craft(item_name):
	play_craft_sound()
	find_parent("UserInterface").holding_item = return_crafted_item(item_name)
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
	PlayerData.craft_item(item_name)
	initialize_crafting()


func hovered_slot(slot):
	if slot.item and not find_parent("UserInterface").holding_item:
		crafting_item = null
		slot.item.hover_item()
		hovered_item = slot.item.item_name

func exited_slot(slot):
	hovered_item = null
	if slot.item:
		slot.item.exit_item()

func return_holding_item(item_name, qt):
	var inventoryItem = InventoryItem.instance()
	inventoryItem.set_item(item_name, qt, null)
	find_parent("UserInterface").add_child(inventoryItem)
	return inventoryItem


func _on_Slider_value_changed(value):
	pass # Replace with function body.
