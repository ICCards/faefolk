extends GridContainer



func initialize():
	show()
	for item in self.get_children():
		if not get_node(item.name + "/button").disabled:
			if PlayerInventory.isSufficientMaterialToCraft(item.name):
				get_node(item.name).modulate = Color(1, 1, 1, 1)
			else:
				get_node(item.name).modulate = Color(1, 1, 1, 0.4)

