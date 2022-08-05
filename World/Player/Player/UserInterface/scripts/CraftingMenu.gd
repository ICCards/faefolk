extends Node2D


var page1 = [
	"wood box",
	"wood barrel",
	"wood fence",
	"torch",
	"wood path",
	"stone path",
	"wood chest",
	"stone chest",
	"campfire",
	"fire pedestal"
]

var page2 = [
	"workbench",
	"stove",
	"grain mill",
	"tall fire pedestal",
	"tent"
]

var page3 = [
	"sleeping bag"
]

var page

func _on_DownButton_pressed():
	play_craft_sound()
	page = 2
	$Page1.visible = false
	$Page2.visible = true
	initialize_crafting()

func _on_UpButton_pressed():
	play_craft_sound()
	page = 1
	$Page1.visible = true
	$Page2.visible = false
	$Page3.visible = false
	initialize_crafting()
	
func _on_Pg2DownButton_pressed():
	play_craft_sound()
	page = 3
	$Page1.visible = false
	$Page2.visible = false
	$Page3.visible = true
	initialize_crafting()

func _on_Pg3UpButton_pressed():
	play_craft_sound()
	page = 2
	$Page1.visible = false
	$Page2.visible = true
	$Page3.visible = false
	initialize_crafting()

	
	
func reset():
	page = 1
	$Page1.visible = true
	$Page2.visible = false
	$Page3.visible = false
	initialize_crafting()


func initialize_crafting():
	if page == 1:
		for item in page1:
			if sufficientMaterialToCraft(item):
				$Page1.get_node(item).modulate = Color(1, 1, 1, 1)
			else:
				$Page1.get_node(item).modulate = Color(1, 1, 1, 0.4)
	elif page == 2:
		for item in page2:
			if sufficientMaterialToCraft(item):
				$Page2.get_node(item).modulate = Color(1, 1, 1, 1)
			else:
				$Page2.get_node(item).modulate = Color(1, 1, 1, 0.4)
	elif page == 3:
		for item in page3:
			if sufficientMaterialToCraft(item):
				$Page3.get_node(item).modulate = Color(1, 1, 1, 1)
			else:
				$Page3.get_node(item).modulate = Color(1, 1, 1, 0.4)


func sufficientMaterialToCraft(item):
	var ingredients = JsonData.crafting_data[item]["ingredients"]
	for i in range(ingredients.size()):
		if PlayerInventory.returnSufficentCraftingMaterial(ingredients[i][0], ingredients[i][1]):
			continue
		else:
			return false
	return true

func _physics_process(delta):
	if item != null:
		$CraftingItemDescription.visible = true
		$CraftingItemDescription.item_name = item
		$CraftingItemDescription.position = get_local_mouse_position() + Vector2(40	, 50)
		$CraftingItemDescription.initialize()
	else:
		$CraftingItemDescription.visible = false

func entered_crafting_area(_item):
	$SoundEffects.stream = Sounds.button_hover
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()
	item = _item
	$Tween.interpolate_property(get_node("Page" + str(page) + "/" + item), "scale",
		get_node("Page" + str(page) + "/" + item).scale, Vector2(3.35, 3.35), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func exited_crafting_area(_item):
	item = null
	if has_node("Page" + str(page) + "/" + _item):
		$Tween.interpolate_property(get_node("Page" + str(page) + "/" + _item), "scale",
			get_node("Page" + str(page) + "/" + _item).scale, Vector2(3, 3), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()


var item = null
func _on_WoodBoxArea_mouse_entered():
	entered_crafting_area("wood box")
func _on_WoodBarrelArea_mouse_entered():
	entered_crafting_area("wood barrel")
func _on_WoodFenceArea_mouse_entered():
	entered_crafting_area("wood fence")
func _on_TorchArea_mouse_entered():
	entered_crafting_area("torch")
func _on_WoodChestArea_mouse_entered():
	entered_crafting_area("wood chest")
func _on_StoneChestArea_mouse_entered():
	entered_crafting_area("stone chest")
func _on_WoodPathArea_mouse_entered():
	entered_crafting_area("wood path")
func _on_StonePathArea_mouse_entered():
	entered_crafting_area("stone path")
func _on_TentArea_mouse_entered():
	entered_crafting_area("tent")
func _on_CampfireArea_mouse_entered():
	entered_crafting_area("campfire")
func _on_FirePedestalArea_mouse_entered():
	entered_crafting_area("fire pedestal")
func _on_TallPedestalArea_mouse_entered():
	entered_crafting_area("tall fire pedestal")
func _on_MachineArea_mouse_entered():
	entered_crafting_area("grain mill")
func _on_CraftingTable_mouse_entered():
	entered_crafting_area("workbench")
func _on_KitchenArea_mouse_entered():
	entered_crafting_area("stove")
func _on_SleepingBagArea_mouse_entered():
	entered_crafting_area("sleeping bag")


func _on_WoodBoxArea_mouse_exited():
	exited_crafting_area("wood box")
func _on_WoodBarrelArea_mouse_exited():
	exited_crafting_area("wood barrel")
func _on_WoodFenceArea_mouse_exited():
	exited_crafting_area("wood fence")
func _on_TorchArea_mouse_exited():
	exited_crafting_area("torch")
func _on_WoodChestArea_mouse_exited():
	exited_crafting_area("wood chest")
func _on_StoneChestArea_mouse_exited():
	exited_crafting_area("stone chest")
func _on_WoodPathArea_mouse_exited():
	exited_crafting_area("wood path")
func _on_StonePathArea_mouse_exited():
	exited_crafting_area("stone path")
func _on_TentArea_mouse_exited():
	exited_crafting_area("tent")
func _on_CampfireArea_mouse_exited():
	exited_crafting_area("campfire")
func _on_FirePedestalArea_mouse_exited():
	exited_crafting_area("fire pedestal")
func _on_TallPedestalArea_mouse_exited():
	exited_crafting_area("tall fire pedestal")
func _on_MachineArea_mouse_exited():
	exited_crafting_area("grain mill")
func _on_CraftingTable_mouse_exited():
	exited_crafting_area("workbench")
func _on_KitchenArea_mouse_exited():
	exited_crafting_area("stove")
func _on_SleepingBagArea_mouse_exited():
	exited_crafting_area("sleeping bag")

func play_craft_sound():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()
	
func play_error_sound():
	$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/ES_Error Tone Chime 6 - SFX Producer.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()
	

func _on_WoodBoxArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft(item):
			play_craft_sound()
			PlayerInventory.craft_item("wood box")
			initialize_crafting()
		else:
			play_error_sound()
func _on_WoodBarrelArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("wood barrel"):
			play_craft_sound()
			PlayerInventory.craft_item("wood barrel")
			initialize_crafting()
		else:
			play_error_sound()
func _on_WoodFenceArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("wood fence"):
			play_craft_sound()
			PlayerInventory.craft_item("wood fence")
			initialize_crafting()
		else:
			play_error_sound()
func _on_TorchArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("torch"):
			play_craft_sound()
			PlayerInventory.craft_item("torch")
			initialize_crafting()
		else:
			play_error_sound()
func _on_WoodChestArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("wood chest"):
			play_craft_sound()
			PlayerInventory.craft_item("wood chest")
			initialize_crafting()
		else:
			play_error_sound()
func _on_StoneChestArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("stone chest"):
			play_craft_sound()
			PlayerInventory.craft_item("stone chest")
			initialize_crafting()
		else:
			play_error_sound()
func _on_WoodPathArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("wood path"):
			play_craft_sound()
			PlayerInventory.craft_item("wood path")
			initialize_crafting()
		else:
			play_error_sound()
func _on_StonePathArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("stone path"):
			play_craft_sound()
			PlayerInventory.craft_item("stone path")
			initialize_crafting()
		else:
			play_error_sound()
func _on_TentArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("tent"):
			play_craft_sound()
			PlayerInventory.craft_item("tent")
			initialize_crafting()
		else:
			play_error_sound()
func _on_CampfireArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("campfire"):
			play_craft_sound()
			PlayerInventory.craft_item("campfire")
			initialize_crafting()
		else:
			play_error_sound()
func _on_FirePedestalArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("fire pedestal"):
			play_craft_sound()
			PlayerInventory.craft_item("fire pedestal")
			initialize_crafting()
		else:
			play_error_sound()
func _on_TallPedestalArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("tall fire pedestal"):
			play_craft_sound()
			PlayerInventory.craft_item("tall fire pedestal")
			initialize_crafting()
		else:
			play_error_sound()
func _on_MachineArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("grain mill"):
			play_craft_sound()
			PlayerInventory.craft_item("grain mill")
			initialize_crafting()
		else:
			play_error_sound()
func _on_CraftingTable_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("workbench"):
			play_craft_sound()
			PlayerInventory.craft_item("workbench")
			initialize_crafting()
		else:
			play_error_sound()
func _on_KitchenArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("stove"):
			play_craft_sound()
			PlayerInventory.craft_item("stove")
			initialize_crafting()
		else:
			play_error_sound()
func _on_SleepingBagArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("sleeping bag"):
			play_craft_sound()
			PlayerInventory.craft_item("sleeping bag")
			initialize_crafting()
		else:
			play_error_sound()

