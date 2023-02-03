extends VBoxContainer


onready var ItemPickUpBox = load("res://InventoryLogic/ItemPickUpBox.tscn")



func item_picked_up(item_name, item_quantity):
	yield(get_tree(), "idle_frame")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	for node in self.get_children():
		if node.item_name == item_name and stack_size != 1:
			modify_existing_box(node,item_quantity)
			return
	add_new_box(item_name,item_quantity)


func modify_existing_box(node,amount_to_add):
	node.item_quantity += amount_to_add
	node.call_deferred("initialize")

func add_new_box(item_name,item_quantity):
	var itemPickUpBox = ItemPickUpBox.instance()
	itemPickUpBox.item_name = item_name
	itemPickUpBox.item_quantity = item_quantity
	itemPickUpBox.delay = self.get_children().size()
	call_deferred("add_child", itemPickUpBox)
