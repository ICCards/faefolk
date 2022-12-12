extends Node

const NUM_INVENTORY_SLOTS = 10
const NUM_HOTBAR_SLOTS = 10

func can_item_be_added_to_inventory(item_name, item_quantity):
	var slot_indices: Array = PlayerData.player_data["hotbar"].keys()
	slot_indices.sort()
	# check if it exists in hotbar
	for item in slot_indices:
		if PlayerData.player_data["hotbar"][item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - PlayerData.player_data["hotbar"][item][1]
			if able_to_add >= item_quantity:
				return true
			else:
				item_quantity = item_quantity - able_to_add
	var inv_slot_indices: Array = PlayerData.player_data["inventory"].keys()
	inv_slot_indices.sort()
	for item in inv_slot_indices:
		if PlayerData.player_data["inventory"][item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - PlayerData.player_data["inventory"][item][1]
			if able_to_add >= item_quantity:
				return true
			else:
				item_quantity = item_quantity - able_to_add
	# item doesn't exist, so add it to an empty hotbar slot
	for i in range(NUM_HOTBAR_SLOTS):
		if PlayerData.player_data["hotbar"].has(str(i)) == false:
			return true
	# item doesn't exist, so add it to an empty inventory slot
	for i in range(NUM_INVENTORY_SLOTS):
		if PlayerData.player_data["inventory"].has(str(i)) == false:
			return true
	return false
