extends Node2D

var item

func _ready():
	initialize()

func initialize():
	$Crafting.hide()
	$Inventory.show()
	$Inventory.initialize()
	$Background/Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/inventory.png")
	$Background/Background.texture = preload("res://Assets/Images/Inventory UI/menus/inventory.png")


func _on_Inventory_pressed():
	if not find_parent("UserInterface").holding_item:
		$Inventory.show()
		$Crafting.hide()
		$Inventory.initialize()
		$Background/Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/inventory.png")
		$Background/Background.texture = preload("res://Assets/Images/Inventory UI/menus/inventory.png")


func _on_Skills_pressed():
	pass
#	$Inventory.hide()
#	$Background/Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/inventory.png")
#	$Background/Background.texture = preload("res://Assets/Images/Inventory UI/menus/skills.png")


func _on_Crafting_pressed():
	if not find_parent("UserInterface").holding_item:
		$Inventory.hide()
		$Crafting.show()
		$Crafting.initialize()
		$Background/Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/crafting.png")
		$Background/Background.texture = preload("res://Assets/Images/Inventory UI/menus/crafting1.png")

func _on_Collections_pressed():
	if not find_parent("UserInterface").holding_item:
		$Inventory.hide()
		$Background/Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/crafting.png")
		$Background/Background.texture = preload("res://Assets/Images/Inventory UI/menus/collections1.png")


func _on_Settings_pressed():
	if not find_parent("UserInterface").holding_item:
		$Inventory.hide()
		$Crafting.hide()
		$Background/Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/settings.png")
		$Background/Background.texture = preload("res://Assets/Images/Inventory UI/menus/settings.png")


func _on_Exit_pressed():
	if not find_parent("UserInterface").holding_item:
		$Inventory.hide()
		$Crafting.hide()
		$Background/Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/exit.png")
		$Background/Background.texture = preload("res://Assets/Images/Inventory UI/menus/exit.png")




#
#
#func _on_Inventory_pressed():
#	set_inventory_state()
#
#func _on_Crafting_pressed():
#	set_crafting_state()
#
#func _on_Options_pressed():
#	set_options_state()
#
#func _on_Quit_pressed():
#	set_quit_state()
#
#func set_inventory_state():
#	pass
##	$InventoryMenu.visible = true
##	$CraftingMenu.visible = false
##	$OptionsMenu.visible = false
##	$QuitMenu.visible = false
##	$Buttons/InventoryIcon.rect_position = Vector2(-102, 4) 
##	$Buttons/CraftingIcon.rect_position = Vector2(-108, 60) 
##	$Buttons/OptionsIcon.rect_position = Vector2(-108, 116) 
##	$Buttons/ExitIcon.rect_position = Vector2(-108, 172) 
##	background.texture = preload("res://Assets/Images/Inventory UI/inventory1.png")
##	$Title.text = "INVENTORY"
##
#func set_crafting_state():
#	$InventoryMenu.visible = false
#	$CraftingMenu.visible = true
#	$OptionsMenu.visible = false
#	$QuitMenu.visible = false
#	$Buttons/InventoryIcon.rect_position = Vector2(-108, 4) 
#	$Buttons/CraftingIcon.rect_position = Vector2(-102, 60) 
#	$Buttons/OptionsIcon.rect_position = Vector2(-108, 116) 
#	$Buttons/ExitIcon.rect_position = Vector2(-108, 172) 
#	background.texture = preload("res://Assets/Images/Inventory UI/inventory2.png")
#	$Title.text = "CRAFTING"
#
#
#func set_options_state():
#	$OptionsMenu.initialize()
#	$InventoryMenu.visible = false
#	$CraftingMenu.visible = false
#	$OptionsMenu.visible = true
#	$QuitMenu.visible = false
#	$Buttons/InventoryIcon.rect_position = Vector2(-108, 4)
#	$Buttons/CraftingIcon.rect_position = Vector2(-108, 60) 
#	$Buttons/OptionsIcon.rect_position = Vector2(-102, 116) 
#	$Buttons/ExitIcon.rect_position = Vector2(-108, 172) 
#	background.texture = preload("res://Assets/Images/Inventory UI/inventory3.png")
#	$Title.text = "OPTIONS"	
#
#func set_quit_state():
#	$InventoryMenu.visible = false
#	$CraftingMenu.visible = false
#	$OptionsMenu.visible = false
#	$QuitMenu.visible = true
#	$Buttons/InventoryIcon.rect_position = Vector2(-108, 4)
#	$Buttons/CraftingIcon.rect_position = Vector2(-108, 60) 
#	$Buttons/OptionsIcon.rect_position = Vector2(-108, 116) 
#	$Buttons/ExitIcon.rect_position = Vector2(-102, 172) 
#	background.texture = preload("res://Assets/Images/Inventory UI/inventory4.png")
#	$Title.text = "QUIT"
#
#
#func _on_ExitButton_input_event(viewport, event, shape_idx):
#	if event.is_action_pressed("mouse_click"):
#		get_parent().toggle_inventory()
#
#
#func _on_ExitToTitleButton_pressed():
#	pass
##	PlayerInventory.viewInventoryMode = false
##	Server.world = null
##	SceneChanger.goto_scene("res://MainMenu/MainMenu.tscn")
#
#func _on_QuitButton_pressed():
#	pass
#	#get_tree().quit()

