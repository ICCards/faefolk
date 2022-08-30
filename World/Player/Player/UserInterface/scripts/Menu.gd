extends Control

var item


func initialize():
	$Crafting.hide()
	$Inventory.show()
	$Collections.hide()
	$Inventory.initialize()
	$OptionsMenu.hide()
	$Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/inventory.png")
	$Background.texture = preload("res://Assets/Images/Inventory UI/menus/inventory.png")
	$Background.rect_position = Vector2(57,84)


func _on_Inventory_pressed():
	if not find_parent("UserInterface").holding_item:
		$Inventory.show()
		$Crafting.hide()
		$Inventory.initialize()
		$Collections.hide()
		$OptionsMenu.hide()
		$Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/inventory.png")
		$Background.texture = preload("res://Assets/Images/Inventory UI/menus/inventory.png")
		$Background.rect_position = Vector2(57,84)

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
		$Collections.hide()
		$OptionsMenu.hide()
		$Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/crafting.png")
		$Background.texture = preload("res://Assets/Images/Inventory UI/menus/crafting1.png")
		$Background.rect_position = Vector2(0,84)

func _on_Collections_pressed():
	if not find_parent("UserInterface").holding_item:
		$Inventory.hide()
		$Crafting.hide()
		$Collections.show()
		$OptionsMenu.hide()
		$Collections.initialize()
		$Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/collections.png")
		$Background.texture = preload("res://Assets/Images/Inventory UI/menus/collections1.png")
		$Background.rect_position = Vector2(-3,84)

func _on_Options_pressed():
	if not find_parent("UserInterface").holding_item:
		$Inventory.hide()
		$Crafting.hide()
		$OptionsMenu.show()
		$Collections.hide()
		$Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/options.png")
		$Background.texture = preload("res://Assets/Images/Inventory UI/menus/options.png")
		$Background.rect_position = Vector2(-9,84)


func _on_Exit_pressed():
	if not find_parent("UserInterface").holding_item:
		$Inventory.hide()
		$Crafting.hide()
		$OptionsMenu.hide()
		$Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/exit.png")
		$Background.texture = preload("res://Assets/Images/Inventory UI/menus/exit.png")


func _on_BackgroundButton_pressed():
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").items_to_drop.append([find_parent("UserInterface").holding_item.item_name, find_parent("UserInterface").holding_item.item_quantity, find_parent("UserInterface").holding_item.item_health])
		#holding_item.item_name, find_parent("UserInterface").holding_item.item_quantity, find_parent("UserInterface").holding_item.item_health)
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null


