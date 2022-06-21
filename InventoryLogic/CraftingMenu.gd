extends Node2D


func _ready():
	initialize_crafting()

func initialize_crafting():
	var wood = PlayerInventory.return_player_wood_and_stone()[0]
	var stone = PlayerInventory.return_player_wood_and_stone()[1]
	for item in JsonData.crafting_data:
		if wood >= JsonData.crafting_data[item]["wood"] and stone >= JsonData.crafting_data[item]["stone"]:
			get_node(item).modulate = Color(1, 1, 1, 1)
		else:
			get_node(item).modulate = Color(1, 1, 1, 0.4)



func _physics_process(delta):
	if item != null:
		$CraftableItemDescription.visible = true
		$CraftableItemDescription/Title.text = item
		$CraftableItemDescription/Materials.text = "Wood: " + str(JsonData.crafting_data[item]["wood"]) + " - Stone: " + str(JsonData.crafting_data[item]["stone"])
		$CraftableItemDescription.position = get_local_mouse_position() + Vector2(140, 100)
	else:
		$CraftableItemDescription.visible = false

func entered_crafting_area(_item):
	item = _item
	if item == "house":
		$Tween.interpolate_property(get_node(item), "scale",
			get_node(item).scale, Vector2(0.545, 0.545), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		$Tween.interpolate_property(get_node(item), "scale",
			get_node(item).scale, Vector2(3.35, 3.35), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	$Tween.start()
	
func exited_crafting_area(_item):
	item = null
	if _item == "house":
		$Tween.interpolate_property(get_node(_item), "scale",
		get_node(_item).scale, Vector2(0.5, 0.5), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		$Tween.interpolate_property(get_node(_item), "scale",
			get_node(_item).scale, Vector2(3, 3), 0.15,
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
func _on_HouseArea_mouse_entered():
	entered_crafting_area("house")



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
func _on_HouseArea_mouse_exited():
	exited_crafting_area("house")




func _on_WoodBoxArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		PlayerInventory.craft_item("wood box")
		initialize_crafting()
func _on_WoodBarrelArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		PlayerInventory.craft_item("wood barrel")
		initialize_crafting()
func _on_WoodFenceArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		PlayerInventory.craft_item("wood fence")
		initialize_crafting()
func _on_TorchArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		PlayerInventory.craft_item("torch")
		initialize_crafting()
func _on_WoodChestArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		PlayerInventory.craft_item("wood chest")
		initialize_crafting()
func _on_StoneChestArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		PlayerInventory.craft_item("stone chest")
		initialize_crafting()
func _on_WoodPathArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		PlayerInventory.craft_item("wood path")
		initialize_crafting()
func _on_StonePathArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		PlayerInventory.craft_item("stone path")
		initialize_crafting()
func _on_HouseArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		PlayerInventory.craft_item("house")
		initialize_crafting()

