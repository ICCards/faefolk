extends Node2D




#set_player_crafting_state(PlayerInventory.return_player_wood_and_stone()[0], PlayerInventory.return_player_wood_and_stone()[1])


func _ready():
	check_inventory_resources()
	#$WoodBox.modulate = Color(1, 1, 1, 0.5)




func check_inventory_resources():
	var wood = PlayerInventory.return_player_wood_and_stone()[0]
	var stone = PlayerInventory.return_player_wood_and_stone()[1]
	#print(str(PlayerInventory.return_player_wood_and_stone()[0]) + " - " + str(PlayerInventory.return_player_wood_and_stone()[1]))
	for item in JsonData.crafting_data:

		#print(JsonData.crafting_data[item]["wood"])
		if wood >= JsonData.crafting_data[item]["wood"] and stone >= JsonData.crafting_data[item]["stone"]:
			get_node(item).modulate = Color(1, 1, 1, 1)
			print(item + " valid resources")
		else:
			get_node(item).modulate = Color(1, 1, 1, 0.5)
			print(item + " invalid resources")
