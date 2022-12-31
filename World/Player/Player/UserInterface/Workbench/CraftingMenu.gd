extends ScrollContainer


onready var InventoryItem = load("res://InventoryLogic/InventoryItem.tscn")
onready var SlotClass = load("res://InventoryLogic/Slot.gd")



func _ready():
	var items = $Items.get_children()
	for i in range(items.size()):
		items[i].connect("gui_input", self, "slot_gui_input", [items[i]])
		items[i].connect("mouse_entered", self, "hovered_slot", [items[i]])
		items[i].connect("mouse_exited", self, "exited_slot", [items[i]])
		items[i].slot_index = i
		items[i].slotType = SlotClass.SlotType.CRAFTING
		items[i].initialize_item(items[i].name,null,null)
	
	
#	for item in $Items.get_children():
#		if not $Items.get_node(item.name + "/button").disabled:
#			if PlayerData.isSufficientMaterialToCraft(item.name):
#				$Items.get_node(item.name).modulate = Color(1, 1, 1, 1)
#			else:
#				$Items.get_node(item.name).modulate = Color(1, 1, 1, 0.4)

func hovered_slot(slot):
	pass
#	if slot.item:
#		slot.item.hover_item()
#		get_parent().hovered_item = slot.item.item_name

func exited_slot(slot):
	pass
#	get_parent().hovered_item = null
#	if slot.item:
#		slot.item.exit_item()

func slot_gui_input(event: InputEvent, slot):
	pass
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT && event.pressed:
#			if find_parent("UserInterface").holding_item != null:
#				Sounds.play_put_down_item_sound()
#				if !slot.item:
#					left_click_empty_slot(slot)
#				else:
#					if find_parent("UserInterface").holding_item.item_name != slot.item.item_name:
#						left_click_different_item(event, slot)
#					else:
#						left_click_same_item(slot)
#			elif slot.item:
#				Sounds.play_pick_up_item_sound()
#				if get_parent().name == "Chest" or get_parent().name == "Tool cabinet":
#					left_click_not_holding_chest(slot)
#				else:
#					left_click_not_holding(slot)
#		elif event.button_index == BUTTON_RIGHT && event.pressed:
#			if slot.item and not find_parent("UserInterface").holding_item:
#				right_click_slot(slot)
