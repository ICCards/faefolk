extends GridContainer



func initialize():
	show()
#	for item in self.get_children():
#		if PlayerInventory.isSufficientMaterialToCraft(item.name):
#			get_node(item.name).modulate = Color(1, 1, 1, 1)
#		else:
#			get_node(item.name).modulate = Color(1, 1, 1, 0.4)
	set_active_buttons()

func set_active_buttons():
	match name:
		"Page1":
			get_node("../Pg1DownButton").show()
			get_node("../Pg2DownButton").hide()
			get_node("../Pg2UpButton").hide()
			get_node("../Pg3UpButton").hide()
		"Page2":
			get_node("../Pg1DownButton").hide()
			get_node("../Pg2DownButton").show()
			get_node("../Pg2UpButton").show()
			get_node("../Pg3UpButton").hide()
		"Page3":
			get_node("../Pg1DownButton").hide()
			get_node("../Pg2DownButton").hide()
			get_node("../Pg2UpButton").hide()
			get_node("../Pg3UpButton").show()

