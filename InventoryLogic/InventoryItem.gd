extends Node2D

var item_name
var item_quantity

		
func set_item(nm, qt):
	item_name = nm
	if item_name == "Cobblestone":
		item_name = "Stone"
	item_quantity = qt
	$TextureRect.texture = load("res://Assets/inventory_icons/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)
	
		
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)
