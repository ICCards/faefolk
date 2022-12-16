extends Control

var level

var crafting_item
var hovered_item
var page

var level_1_items = ["wood axe", "wood pickaxe", "wood hoe", "wood sword", "stone axe", "stone pickaxe", "stone hoe", "stone sword","stone watering can", "wood fishing rod", "scythe", "arrow"]
var level_2_items = ["bronze axe", "bronze pickaxe", "bronze hoe", "bronze sword", "bronze watering can", "stone fishing rod"]

onready var SlotClass = load("res://InventoryLogic/Slot.gd")
onready var InventoryItem = load("res://InventoryLogic/InventoryItem.tscn")

func _ready():
	initialize()

func initialize():
	$InventorySlots.initialize_slots()
	$HotbarInventorySlots.initialize_slots()
	Server.player_node.actions.destroy_placable_object()
	page = 1
	hovered_item = null
	crafting_item = null
	$Title.text = "Workbench #" + str(level) + ":"
	show()
	set_current_page()
	
func destroy():
	set_physics_process(false)
	$ItemDescription.set_physics_process(false)
	$ItemDescription.queue_free()
	$CraftingItemDescription.queue_free()
	$ItemNameBox.queue_free()
	queue_free()

func _physics_process(delta):
	if hovered_item and not find_parent("UserInterface").holding_item:
		$ItemDescription.show()
		$ItemDescription.item_category = JsonData.item_data[hovered_item]["ItemCategory"]
		$ItemDescription.item_name = hovered_item
		$ItemDescription.initialize()
		$ItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
	else:
		$ItemDescription.hide()
	if crafting_item and not find_parent("UserInterface").holding_item:
		if page == 1 and get_node("Page1/"+crafting_item+"/button").disabled:
			$CraftingItemDescription.hide()
			$ItemNameBox.show()
			$ItemNameBox.position = get_local_mouse_position() + Vector2(20 , 25)
		elif page == 2 and get_node("Page2/"+crafting_item+"/button").disabled:
			$CraftingItemDescription.hide()
			$ItemNameBox.show()
			$ItemNameBox.position = get_local_mouse_position() + Vector2(20 , 25)
		else:
			$ItemNameBox.hide()
			$CraftingItemDescription.show()
			$CraftingItemDescription.item_name = crafting_item
			$CraftingItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
			$CraftingItemDescription.initialize()
	else:
		$ItemNameBox.hide()
		$CraftingItemDescription.hide()


func entered_crafting_area(item_name):
	crafting_item = item_name
	match page:
		1:
			$Tween.interpolate_property($Page1.get_node(item_name), "rect_scale",
				$Page1.get_node(item_name).rect_scale, Vector2(1.1, 1.1), 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
		2:
			$Tween.interpolate_property($Page2.get_node(item_name), "rect_scale",
				$Page2.get_node(item_name).rect_scale, Vector2(1.1, 1.1), 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
		3:
			$Tween.interpolate_property($Page3.get_node(item_name), "rect_scale",
				$Page3.get_node(item_name).rect_scale, Vector2(1.1, 1.1), 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()

func exited_crafting_area(item_name):
	crafting_item = null
	match page:
		1:
			$Tween.interpolate_property($Page1.get_node(item_name), "rect_scale",
				$Page1.get_node(item_name).rect_scale, Vector2(1.0, 1.0), 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
		2:
			$Tween.interpolate_property($Page2.get_node(item_name), "rect_scale",
				$Page2.get_node(item_name).rect_scale, Vector2(1.0, 1.0), 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
		3:
			$Tween.interpolate_property($Page3.get_node(item_name), "rect_scale",
				$Page3.get_node(item_name).rect_scale, Vector2(1.0, 1.0), 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()

func craft(item_name):
	if not get_parent().holding_item and PlayerData.isSufficientMaterialToCraft(item_name):
		find_parent("UserInterface").holding_item = return_crafted_item(item_name)
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
		PlayerData.craft_item(item_name)
		set_current_page()
	elif find_parent("UserInterface").holding_item:
		if find_parent("UserInterface").holding_item.item_name == "arrow" and PlayerData.isSufficientMaterialToCraft(item_name):
			PlayerData.craft_item(item_name)
			find_parent("UserInterface").holding_item.add_item_quantity(1)
			set_current_page()

func return_crafted_item(item_name):
	var inventoryItem = InventoryItem.instance()
	inventoryItem.set_item(item_name, 1, Stats.return_max_tool_health(item_name))
	find_parent("UserInterface").add_child(inventoryItem)
	return inventoryItem

func _on_DownButton_pressed():
	if page != 3:
		page += 1
	set_current_page()
	

func _on_UpButton_pressed():
	if page != 1:
		page -= 1
	set_current_page()
	
func set_current_page():
	match page:
		1:
			$Page1.initialize()
			$Page2.hide()
			$Page3.hide()
			$UpButton.hide()
			$DownButton.show()
		2:
			$Page3.hide()
			$Page2.initialize()
			$Page1.hide()
			$UpButton.show()
			$DownButton.show()
		3:
			$Page3.initialize()
			$Page2.hide()
			$Page1.hide()
			$UpButton.show()
			$DownButton.hide()


func _on_ExitButton_pressed():
	get_parent().close_workbench()
