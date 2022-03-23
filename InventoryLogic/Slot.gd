extends Panel


var ItemClass = preload("res://InventoryLogic/Item.tscn")
var item = null
var slot_index


func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.add_child(item)
	item = null
	
func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	add_child(item)
	
func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
		
