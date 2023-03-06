extends VBoxContainer


@onready var ItemPickUpBox = load("res://InventoryLogic/ItemPickUpBox.tscn")

var queue = []
var thread := Thread.new()

func item_picked_up(item_name, item_quantity):
	queue.append([item_name, item_quantity])
	if thread.is_started():
		return
	thread.start(Callable(self,"show_dialogue"))
	

func show_dialogue():
	call_deferred("modify_or_add_to_box")
	
func modify_or_add_to_box():
	var item_name = queue[0][0]
	var item_quantity = queue[0][1]
	if item_name == "Inventory full!":
		add_or_extend_inventory_full_box()
		repeat_or_end_thread()
		return
	else:
		var stack_size = int(JsonData.item_data[item_name]["StackSize"])
		for node in self.get_children():
			if node.item_name == item_name and stack_size != 1:
				modify_existing_box(node,item_quantity)
				repeat_or_end_thread()
				return
		add_new_box(item_name,item_quantity)
		repeat_or_end_thread()
		return
		
func add_or_extend_inventory_full_box():
	for node in self.get_children():
		if node.item_name == "Inventory full!":
			node.call_deferred("initialize")
			return
	var itemPickUpBox = ItemPickUpBox.instantiate()
	itemPickUpBox.item_name = "Inventory full!"
	itemPickUpBox.delay = self.get_children().size()
	call_deferred("add_child", itemPickUpBox)


func repeat_or_end_thread():
	queue.remove_at(0)
	if not queue.is_empty():
		show_dialogue()
		return
	thread.wait_to_finish()
	return


func modify_existing_box(node,amount_to_add):
	node.item_quantity += amount_to_add
	node.call_deferred("initialize")

func add_new_box(item_name,item_quantity):
	var itemPickUpBox = ItemPickUpBox.instantiate()
	itemPickUpBox.item_name = item_name
	itemPickUpBox.item_quantity = item_quantity
	itemPickUpBox.delay = self.get_children().size()
	call_deferred("add_child", itemPickUpBox)
