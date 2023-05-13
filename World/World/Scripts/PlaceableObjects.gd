extends Node2D

@rpc
func player_remove_object(player_id,type,id,data): pass

@rpc
func player_place_object(player_id,type,id,data): pass

@rpc
func placeable_object_hit(peer_id,id,loc,tool_name):pass

@rpc
func player_interact_with_object(data): pass

@rpc
func send_updated_ui_slots(id,dict): pass

@rpc 
func player_move_object(player_id,id,data): pass

@rpc 
func player_repair_object(data): pass
@rpc
func player_upgrade_object(data): pass
#
@rpc
func upgrade(data):
	var chunk = MapData.get_chunk_from_location(data["l"])
	if get_node("../").world[chunk]["placeable"].has(data["id"]):
		var new_tier = data["t"]
		get_node("../").world[chunk]["placeable"][data["id"]]["t"] = new_tier
		get_node("../").world[chunk]["placeable"][data["id"]]["h"] = Stats.return_max_building_health(new_tier) 
		for node in self.get_children():
			if node.name == data["id"]:
				node.upgrade(new_tier)
				return
@rpc
func repair(data):
	var chunk = MapData.get_chunk_from_location(data["l"])
	if get_node("../").world[chunk]["placeable"].has(data["id"]):
		var item_name = get_node("../").world[chunk]["placeable"][data["id"]]["n"]
		if item_name == "foundation" or item_name == "wall": 
			var current_tier = get_node("../").world[chunk]["placeable"][data["id"]]["t"]
			get_node("../").world[chunk]["placeable"][data["id"]]["h"] = Stats.return_max_building_health(current_tier)
		else:
			get_node("../").world[chunk]["placeable"][data["id"]]["h"] = Stats.return_max_door_health(item_name)
		for node in self.get_children():
			if node.name == data["id"]:
				node.repair()
				return

@rpc 
func place_object_in_new_location(player_id,id,prev_object_data,data):
	var old_chunk = MapData.get_chunk_from_location(prev_object_data["l"])
	if not player_id == Server.player_node.name and get_node("../").world[old_chunk]["placeable"].has(id):
		get_node("../").world[old_chunk]["placeable"].erase(id)
		var chunk = MapData.get_chunk_from_location(data["l"])
		get_node("../").world[chunk]["placeable"][id] = data
		get_node("../").world[chunk]["placeable"][id]["o"] = false
		for node in self.get_children():
			if node.name == str(id):
				var dimensions = Constants.dimensions_dict[data["n"]]
				if prev_object_data["d"] == "left" or prev_object_data["d"] == "right":
					Tiles.add_valid_tiles(prev_object_data["l"], Vector2(dimensions.y, dimensions.x))
				else:
					Tiles.add_valid_tiles(prev_object_data["l"], dimensions)
				Tiles.object_tiles.erase_cell(0,prev_object_data["l"])
				get_node(str(id)).global_position = Tiles.valid_tiles.map_to_local(data["l"])
				get_node(str(id)).variety = data["v"]
				get_node(str(id)).direction = data["d"]
				get_node(str(id)).location = data["l"]
				get_node(str(id)).opened_or_light_toggled = false
				get_node(str(id)).initialize()
				return
			

@rpc
func update_ui_slots(id,data): 
	if not get_node("../").server_data == {}:
		get_node("../").server_data["ui_slots"][id] = data


@rpc
func update_placeable_health(data): 
	if get_node("../").world[data["chunk"]]["placeable"].has(data["id"]):
		get_node("../").world[data["chunk"]]["placeable"][data["id"]]["h"] = data["health"]
		for node in self.get_children():
			if node.name == data["id"]:
				get_node(str(data["id"])).hit(data)
				return

@rpc
func destroy_placeable_object(data):
	if get_node("../").world[data["chunk"]]["placeable"].has(data["id"]):
		if get_node("../").server_data["ui_slots"].has([data["id"]]): # clear ui slots
				get_node("../").server_data.erase([data["id"]])
		get_node("../").world[data["chunk"]]["placeable"].erase(data["id"])
		for node in self.get_children():
			if node.name == data["id"]:
				get_node(str(data["id"])).destroy(data)
				return

@rpc
func add_new_object_to_world(player_id,type,id,data): 
	if not get_node("../").server_data == {}:
		if type == "placeable":
			if Util.isCookingItem(data["n"]):
				get_parent().server_data["ui_slots"][id] = {"tr":0,"lo":null}
			else:
				get_parent().server_data["ui_slots"][id] = {}
		if Server.player_node:
			if player_id == Server.player_node.name:
				return
		var chunk = MapData.get_chunk_from_location(data["l"])
		if get_node("../WorldBuilder").current_chunks.has(chunk):
			PlaceObject.place(type,id,data)
			get_parent().world[chunk][type][id] = data


@rpc
func change_object_data(data): 
	if get_node("../").world[data["chunk"]]["placeable"].has(data["id"]):
		get_node("../").world[data["chunk"]]["placeable"][data["id"]]["o"] = data["o"]
		for node in self.get_children():
			if node.name == data["id"]:
				node.change(data["o"])
				return
