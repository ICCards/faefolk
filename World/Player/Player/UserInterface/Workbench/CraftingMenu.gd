extends ScrollContainer


@onready var InventoryItem = load("res://InventoryLogic/InventoryItem.tscn")
@onready var SlotClass = load("res://InventoryLogic/Slot.gd")

var hovered_item = null

func _ready():
	var items = $Items.get_children()
	for i in range(items.size()):
		items[i].connect("gui_input",Callable(self,"slot_gui_input").bind(items[i))
		items[i].connect("mouse_entered",Callable(self,"hovered_slot").bind(items[i))
		items[i].connect("mouse_exited",Callable(self,"exited_slot").bind(items[i))
		items[i].slot_index = i
		items[i].slotType = SlotClass.SlotType.CRAFTING
		items[i].initialize_item(items[i].name,null,null)
#
	
#	for item in $Items.get_children():
#		if not $Items.get_node(item.name + "/button").disabled:
#			if PlayerData.isSufficientMaterialToCraft(item.name):
#				$Items.get_node(item.name).modulate = Color(1, 1, 1, 1)
#			else:
#				$Items.get_node(item.name).modulate = Color(1, 1, 1, 0.4)

func hovered_slot(slot):
	if slot.item:
		slot.item.hover_crafting_item()
		get_parent().crafting_item = slot.item.item_name

func exited_slot(slot):
	get_parent().crafting_item = null
	if slot.item:
		slot.item.exit_crafting_item()

func entered_crafting_area(_item):
	await get_tree().idle_frame
	hovered_item = _item
	if hovered_item == "blueprint" or hovered_item == "hammer" or hovered_item == "wood sword" or hovered_item == "wood axe" or hovered_item == "wood pickaxe" or hovered_item == "wood hoe":
		$Tween.interpolate_property(get_node("CraftingMenu/Items/" + hovered_item), "scale",
			get_node("CraftingMenu/Items/" + hovered_item).scale, Vector2(4.2, 4.2), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		$Tween.interpolate_property(get_node("CraftingMenu/Items/" + hovered_item), "scale",
			get_node("CraftingMenu/Items/" + hovered_item).scale, Vector2(2.1, 2.1), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
	
func exited_crafting_area(_item):
	hovered_item = null
	if has_node("CraftingMenu/Items/" + hovered_item):
		if hovered_item == "blueprint" or hovered_item == "hammer" or hovered_item == "wood sword" or hovered_item == "wood axe" or hovered_item == "wood pickaxe" or hovered_item == "wood hoe":
			$Tween.interpolate_property(get_node("CraftingMenu/Items/" + hovered_item), "scale",
				get_node("CraftingMenu/Items/" + hovered_item).scale, Vector2(4, 4), 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
		else:
			$Tween.interpolate_property(get_node("CraftingMenu/Items/" + hovered_item), "scale",
				get_node("CraftingMenu/Items/" + hovered_item).scale, Vector2(2, 2), 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()



func slot_gui_input(event: InputEvent, slot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			#if find_parent("UserInterface").holding_item != null:
			#Sounds.play_put_down_item_sound()
#			if !slot.item:
			get_parent().craftable_item_pressed(slot.item.item_name)
#			else:
#				if find_parent("UserInterface").holding_item.item_name != slot.item.item_name:
#					#left_click_different_item(event, slot)
#					get_parent().craft()
#				else:
#					#left_click_same_item(slot)
#					get_parent().craft()

