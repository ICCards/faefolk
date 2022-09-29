extends Control

onready var inventory_slots = $InventorySlots
onready var hotbar_slots = $HotbarSlots
const SlotClass = preload("res://InventoryLogic/Slot.gd")
var crafting_item = null
var item = null
var page = 1
onready var InventoryItem = preload("res://InventoryLogic/InventoryItem.tscn")

var page1 = [
	"wood box",
	"wood barrel",
	"wood fence",
	"torch",
	"wood chest",
	"stone chest",
	"campfire",
	"sleeping bag",
	"workbench #1",
	"workbench #2"
]

var page2 = [
	"workbench #3",
	"grain mill #1",
	"grain mill #2",
	"grain mill #3",
	"stove #1",
]
var page3 = [
	"stove #2",
	"stove #3",
	"tent",
	"wood door",
	"metal door"
]

var page4 = [
	"armored door",
	"furnace",
	"hammer",
	"blueprint",
	"tool cabinet",
	"wood axe",
	"wood pickaxe",
	"wood sword",
	"wood hoe"
]


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
	$Page1.show()
	$Page2.hide()
	$Page3.hide()
	$Page4.hide()
	reset_hover_effect()
	initialize_crafting()

func _on_DownButton_pressed():
	play_craft_sound()
	page = 2
	$Page1.hide()
	$Page2.show()
	$Page3.hide()
	$Page4.hide()
	initialize_crafting()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/crafting3.png")

func _on_Pg2UpButton_pressed():
	play_craft_sound()
	page = 1
	$Page1.show()
	$Page2.hide()
	$Page3.hide()
	$Page4.hide()
	initialize_crafting()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/crafting1.png")
	
func _on_Pg2DownButton_pressed():
	play_craft_sound()
	page = 3
	$Page1.hide()
	$Page2.hide()
	$Page3.show()
	$Page4.hide()
	initialize_crafting()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/crafting3.png")

	
func _on_Pg3UpButton_pressed():
	play_craft_sound()
	page = 2
	$Page1.hide()
	$Page2.show()
	$Page3.hide()
	$Page4.hide()
	initialize_crafting()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/crafting3.png")


func _on_Pg3DownButton_pressed():
	play_craft_sound()
	page = 4
	$Page1.hide()
	$Page2.hide()
	$Page3.hide()
	$Page4.show()
	initialize_crafting()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/crafting2.png")

func _on_Pg4UpButton_pressed():
	play_craft_sound()
	page = 3
	$Page1.hide()
	$Page2.hide()
	$Page3.show()
	$Page4.hide()
	initialize_crafting()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/crafting3.png")

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


func reset_hover_effect():
	for item in page1:
		$Page1.get_node(item).scale = Vector2(3,3)
	for item in page2:
		$Page2.get_node(item).scale = Vector2(3,3)
	for item in page3:
		$Page3.get_node(item).scale = Vector2(3,3)
	for item in page4:
		if item == "blueprint" or item == "hammer" or item == "wood sword" or item == "wood axe" or item == "wood pickaxe" or item == "wood hoe":
			$Page4.get_node(item).scale = Vector2(6,6)
		else:
			$Page4.get_node(item).scale = Vector2(3,3)

func initialize_crafting():
	PlayerInventory.HotbarSlots = $HotbarSlots
	PlayerInventory.InventorySlots = $InventorySlots
	intialize_slots()
	if page == 1:
		for item in page1:
			if PlayerInventory.isSufficientMaterialToCraft(item):
				$Page1.get_node(item).modulate = Color(1, 1, 1, 1)
			else:
				$Page1.get_node(item).modulate = Color(1, 1, 1, 0.4)
	elif page == 2:
		for item in page2:
			if PlayerInventory.isSufficientMaterialToCraft(item):
				$Page2.get_node(item).modulate = Color(1, 1, 1, 1)
			else:
				$Page2.get_node(item).modulate = Color(1, 1, 1, 0.4)
	elif page == 3:
		for item in page3:
			if PlayerInventory.isSufficientMaterialToCraft(item):
				$Page3.get_node(item).modulate = Color(1, 1, 1, 1)
			else:
				$Page3.get_node(item).modulate = Color(1, 1, 1, 0.4)
	elif page == 4:
		for item in page4:
			if PlayerInventory.isSufficientMaterialToCraft(item):
				$Page4.get_node(item).modulate = Color(1, 1, 1, 1)
			else:
				$Page4.get_node(item).modulate = Color(1, 1, 1, 0.4)
 

func _physics_process(delta):
	if not visible:
		return
	if item and not find_parent("UserInterface").holding_item:
		$ItemDescription.visible = true
		$ItemDescription.item_category = JsonData.item_data[item]["ItemCategory"]
		$ItemDescription.item_name = item
		$ItemDescription.position = get_local_mouse_position() + Vector2(55 , 75)
		$ItemDescription.initialize()
	else:
		$ItemDescription.visible = false
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
		$Tween.interpolate_property(get_node("Page" + str(page) + "/" + crafting_item), "scale",
			get_node("Page" + str(page) + "/" + crafting_item).scale, Vector2(6.7, 6.7), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		$Tween.interpolate_property(get_node("Page" + str(page) + "/" + crafting_item), "scale",
			get_node("Page" + str(page) + "/" + crafting_item).scale, Vector2(3.35, 3.35), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
	
func exited_crafting_area(_item):
	crafting_item = null
	if has_node("Page" + str(page) + "/" + _item):
		if _item == "blueprint" or _item == "hammer" or _item == "wood sword" or _item == "wood axe" or _item == "wood pickaxe" or _item == "wood hoe":
			$Tween.interpolate_property(get_node("Page" + str(page) + "/" + _item), "scale",
				get_node("Page" + str(page) + "/" + _item).scale, Vector2(6, 6), 0.15,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
		else:
			$Tween.interpolate_property(get_node("Page" + str(page) + "/" + _item), "scale",
				get_node("Page" + str(page) + "/" + _item).scale, Vector2(3, 3), 0.15,
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
	
	
func craftable_item_pressed():
	if PlayerInventory.isSufficientMaterialToCraft(crafting_item) and not find_parent("UserInterface").holding_item:
		craft(crafting_item)
	elif find_parent("UserInterface").holding_item:
		if find_parent("UserInterface").holding_item.item_name == crafting_item and PlayerInventory.isSufficientMaterialToCraft(crafting_item) and JsonData.item_data[crafting_item]["StackSize"] != 1:
			PlayerInventory.craft_item(crafting_item)
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


func _on_WoodBoxButton_mouse_entered():
	entered_crafting_area("wood box")
func _on_WoodBoxButton_mouse_exited():
	exited_crafting_area("wood box")
func _on_WoodBoxButton_pressed():
	craftable_item_pressed()

func _on_WoodBarrelButton_mouse_entered():
	entered_crafting_area("wood barrel")
func _on_WoodBarrelButton_mouse_exited():
	exited_crafting_area("wood barrel")
func _on_WoodBarrelButton_pressed():
	craftable_item_pressed()

func _on_WoodFenceButton_mouse_entered():
	entered_crafting_area("wood fence")
func _on_WoodFenceButton_mouse_exited():
	exited_crafting_area("wood fence")
func _on_WoodFenceButton_pressed():
	craftable_item_pressed()

func _on_TorchButton_mouse_entered():
	entered_crafting_area("torch")
func _on_TorchButton_mouse_exited():
	exited_crafting_area("torch")
func _on_TorchButton_pressed():
	craftable_item_pressed()

func _on_CampfireButton_mouse_entered():
	entered_crafting_area("campfire")
func _on_CampfireButton_mouse_exited():
	exited_crafting_area("campfire")
func _on_CampfireButton_pressed():
	craftable_item_pressed()
	
func _on_WoodChestButton_mouse_entered():
	entered_crafting_area("wood chest")
func _on_WoodChestButton_mouse_exited():
	exited_crafting_area("wood chest")
func _on_WoodChestButton_pressed():
	craftable_item_pressed()

func _on_StoneChestButton_mouse_entered():
	entered_crafting_area("stone chest")
func _on_StoneChestButton_mouse_exited():
	exited_crafting_area("stone chest")
func _on_StoneChestButton_pressed():
	craftable_item_pressed()

func _on_SleepingBagButton_mouse_entered():
	entered_crafting_area("sleeping bag")
func _on_SleepingBagButton_mouse_exited():
	exited_crafting_area("sleeping bag")
func _on_SleepingBagButton_pressed():
	craftable_item_pressed()

func _on_TentButton_mouse_entered():
	entered_crafting_area("tent")
func _on_TentButton_mouse_exited():
	exited_crafting_area("tent")
func _on_TentButton_pressed():
	craftable_item_pressed()
	
func _on_WorkbenchButton_mouse_entered():
	entered_crafting_area("workbench #1")
func _on_WorkbenchButton_mouse_exited():
	exited_crafting_area("workbench #1")
func _on_WorkbenchButton_pressed():
	craftable_item_pressed()

func _on_WorkbenchButton2_mouse_entered():
	entered_crafting_area("workbench #2")
func _on_WorkbenchButton2_mouse_exited():
	exited_crafting_area("workbench #2")
func _on_WorkbenchButton2_pressed():
	craftable_item_pressed()


func _on_WorkbenchButton3_mouse_exited():
	exited_crafting_area("workbench #3")
func _on_WorkbenchButton3_mouse_entered():
	entered_crafting_area("workbench #3")
func _on_WorkbenchButton3_pressed():
	craftable_item_pressed()

func _on_GrainMillButton_mouse_entered():
	entered_crafting_area("grain mill #1")
func _on_GrainMillButton_mouse_exited():
	exited_crafting_area("grain mill #1")
func _on_GrainMillButton_pressed():
	craftable_item_pressed()

func _on_GrainMillButton2_pressed():
	craftable_item_pressed()
func _on_GrainMillButton2_mouse_entered():
	entered_crafting_area("grain mill #2")
func _on_GrainMillButton2_mouse_exited():
	exited_crafting_area("grain mill #2")

func _on_GrainMillButton3_pressed():
	craftable_item_pressed()
func _on_GrainMillButton3_mouse_entered():
	entered_crafting_area("grain mill #3")

func _on_GrainMillButton3_mouse_exited():
	exited_crafting_area("grain mill #3")


func _on_KitchenButton_mouse_entered():
	entered_crafting_area("stove #1")
func _on_KitchenButton_mouse_exited():
	exited_crafting_area("stove #1")
func _on_KitchenButton_pressed():
	craftable_item_pressed()

func _on_StoveButton2_mouse_entered():
	entered_crafting_area("stove #2")
func _on_StoveButton2_mouse_exited():
	exited_crafting_area("stove #2")
func _on_StoveButton2_pressed():
	craftable_item_pressed()


func _on_StoveButton3_mouse_entered():
	entered_crafting_area("stove #3")
func _on_StoveButton3_mouse_exited():
	exited_crafting_area("stove #3")
func _on_StoveButton3_pressed():
	craftable_item_pressed()


func _on_DoorButton_pressed():
	craftable_item_pressed()
func _on_DoorButton_mouse_entered():
	entered_crafting_area("wood door")
func _on_DoorButton_mouse_exited():
	exited_crafting_area("wood door")


func _on_BlueprintButton_pressed():
	craftable_item_pressed()
func _on_BlueprintButton_mouse_entered():
	entered_crafting_area("blueprint")
func _on_BlueprintButton_mouse_exited():
	exited_crafting_area("blueprint")

func _on_HammerButton_pressed():
	craftable_item_pressed()
func _on_HammerButton_mouse_entered():
	entered_crafting_area("hammer")
func _on_HammerButton_mouse_exited():
	exited_crafting_area("hammer")

func _on_MetalDoorButton_pressed():
	craftable_item_pressed()
func _on_MetalDoorButton_mouse_entered():
	entered_crafting_area("metal door")
func _on_MetalDoorButton_mouse_exited():
	exited_crafting_area("metal door")


func _on_FurnaceButton_pressed():
	craftable_item_pressed()
func _on_FurnaceButton_mouse_entered():
	entered_crafting_area("furnace")
func _on_FurnaceButton_mouse_exited():
	exited_crafting_area("furnace")


func _on_ArmoredDoor_pressed():
	craftable_item_pressed()
func _on_ArmoredDoor_mouse_entered():
	entered_crafting_area("armored door")
func _on_ArmoredDoor_mouse_exited():
	exited_crafting_area("armored door")


func _on_ToolCabinetButton_pressed():
	craftable_item_pressed()
func _on_ToolCabinetButton_mouse_entered():
	entered_crafting_area("tool cabinet")
func _on_ToolCabinetButton_mouse_exited():
	exited_crafting_area("tool cabinet")


func _on_WoodAxeButton_pressed():
	craftable_item_pressed()
func _on_WoodAxeButton_mouse_entered():
	entered_crafting_area("wood axe")
func _on_WoodAxeButton_mouse_exited():
	exited_crafting_area("wood axe")


func _on_WoodPickaxeButton_pressed():
	craftable_item_pressed()
func _on_WoodPickaxeButton_mouse_entered():
	entered_crafting_area("wood pickaxe")
func _on_WoodPickaxeButton_mouse_exited():
	exited_crafting_area("wood pickaxe")


func _on_WoodHoeButton_pressed():
	craftable_item_pressed()
func _on_WoodHoeButton_mouse_entered():
	entered_crafting_area("wood hoe")
func _on_WoodHoeButton_mouse_exited():
	exited_crafting_area("wood hoe")


func _on_WoodSwordButton_pressed():
	craftable_item_pressed()
func _on_WoodSwordButton_mouse_entered():
	entered_crafting_area("wood sword")
func _on_WoodSwordButton_mouse_exited():
	exited_crafting_area("wood sword")
