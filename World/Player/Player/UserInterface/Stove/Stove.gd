extends Control

var object_tiles
var level 
var crafting_item
var item
var page
var level_1_items = ["cooked filet", "cooked wing", "bread", "cooked corn", "mushroom soup",  "tomato soup"]
var level_2_items = ["baked zucchini", "blowfish tails", "asparagus omelette", "cooked green beans", "cauliflower soup", "potatoes with asparagus"]
 
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


func _physics_process(delta):
	if item and not find_parent("UserInterface").holding_item:
		$ItemDescription.show()
		$ItemDescription.item_category = JsonData.item_data[item]["ItemCategory"]
		$ItemDescription.item_name = item
		$ItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
		$ItemDescription.initialize()
	else:
		$ItemDescription.hide()
	if crafting_item: #and not find_parent("UserInterface").holding_item:
		if page == 1 and get_node("Page1/"+crafting_item+"/button").disabled:
			$ItemNameBox.show()
			$ItemNameBox.position = get_local_mouse_position() + Vector2(20 , 25)
		elif page == 2 and get_node("Page2/"+crafting_item+"/button").disabled:
			$ItemNameBox.show()
			$ItemNameBox.position = get_local_mouse_position() + Vector2(20 , 25)
		elif page == 3 and get_node("Page3/"+crafting_item+"/button").disabled:
			$ItemNameBox.show()
			$ItemNameBox.position = get_local_mouse_position() + Vector2(20 , 25)
		else:
			$CraftingItemDescription.show()
			$CraftingItemDescription.item_name = crafting_item
			$CraftingItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
			$CraftingItemDescription.initialize()
	else:
		$ItemNameBox.hide()
		$CraftingItemDescription.hide()



func initialize():
	show()
	$Title.text = level[0].to_upper() + level.substr(1,-1) + ":"
	$Page1.initialize()
	$Page2.hide()
	$Page3.hide()
	page = 1


func _on_ExitButton_pressed():
	if not get_parent().holding_item:
		get_parent().close_stove()


func _on_Pg1DownButton_pressed():
	$Page1.hide()
	$Page2.initialize()
	$Page3.hide()
	page = 2
	

func _on_Pg2DownButton_pressed():
	$Page3.initialize()
	$Page2.hide()
	$Page1.hide()
	page = 3
	

func _on_Pg2UpButton_pressed():
	$Page1.initialize()
	$Page2.hide()
	$Page3.hide()
	page = 1


func _on_Pg3UpButton_pressed():
	$Page1.hide()
	$Page2.initialize()
	$Page3.hide()
	page = 2
