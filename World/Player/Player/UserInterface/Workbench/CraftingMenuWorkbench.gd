extends ScrollContainer



func _ready():
	for item in $Items.get_children():
		if not $Items.get_node(item.name + "/button").disabled:
			if PlayerData.isSufficientMaterialToCraft(item.name):
				$Items.get_node(item.name).modulate = Color(1, 1, 1, 1)
			else:
				$Items.get_node(item.name).modulate = Color(1, 1, 1, 0.4)
