extends Node2D

const SlotClass = preload("res://InventoryLogic/Slot.gd")
onready var inventory_slots = $InventorySlots
onready var background = $Background


func _ready():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slotType = SlotClass.SlotType.INVENTORY
	initialize_inventory()

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if slots[i].item != null:
			slots[i].removeFromSlot()
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
	set_inventory_state()

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

func _input(_event):
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

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


func _on_Inventory_pressed():
	set_inventory_state()

func _on_Crafting_pressed():
	set_crafting_state()

func _on_Options_pressed():
	set_options_state()

func _on_Quit_pressed():
	set_quit_state()
	
func set_inventory_state():
	$InventorySlots.visible = true
	$CraftingMenu.visible = false
	$OptionsMenu.visible = false
	$QuitMenu.visible = false
	$Buttons/InventoryIcon.rect_position = Vector2(-202, 8) 
	$Buttons/CraftingIcon.rect_position = Vector2(-218, 116) 
	$Buttons/OptionsIcon.rect_position = Vector2(-218, 224) 
	$Buttons/ExitIcon.rect_position = Vector2(-218, 332) 
	background.texture = preload("res://Assets/Images/Inventory UI/inventory1.png")
	$Title.text = "INVENTORY"
	
func set_crafting_state():
	$InventorySlots.visible = false
	$CraftingMenu.visible = true
	$OptionsMenu.visible = false
	$QuitMenu.visible = false
	$Buttons/InventoryIcon.rect_position = Vector2(-218, 8) 
	$Buttons/CraftingIcon.rect_position = Vector2(-202, 116) 
	$Buttons/OptionsIcon.rect_position = Vector2(-218, 224) 
	$Buttons/ExitIcon.rect_position = Vector2(-218, 332) 
	background.texture = preload("res://Assets/Images/Inventory UI/inventory2.png")
	$Title.text = "CRAFTING"
	
	
func set_options_state():
	$InventorySlots.visible = false
	$CraftingMenu.visible = false
	$OptionsMenu.visible = true
	$QuitMenu.visible = false
	$Buttons/InventoryIcon.rect_position = Vector2(-218, 8)
	$Buttons/CraftingIcon.rect_position = Vector2(-218, 116) 
	$Buttons/OptionsIcon.rect_position = Vector2(-202, 224) 
	$Buttons/ExitIcon.rect_position = Vector2(-218, 332) 
	background.texture = preload("res://Assets/Images/Inventory UI/inventory3.png")
	$Title.text = "OPTIONS"	

func set_quit_state():
	$InventorySlots.visible = false
	$CraftingMenu.visible = false
	$OptionsMenu.visible = false
	$QuitMenu.visible = true
	$Buttons/InventoryIcon.rect_position = Vector2(-218, 8)
	$Buttons/CraftingIcon.rect_position = Vector2(-218, 116) 
	$Buttons/OptionsIcon.rect_position = Vector2(-218, 224) 
	$Buttons/ExitIcon.rect_position = Vector2(-202, 332) 
	background.texture = preload("res://Assets/Images/Inventory UI/inventory4.png")
	$Title.text = "QUIT"


func _on_ExitButton_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		get_parent().toggle_inventory()


func _on_ExitToTitleButton_pressed():
	PlayerInventory.viewInventoryMode = false
	Server.world = null
	SceneChanger.change_scene("res://MainMenu/MainMenu.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
