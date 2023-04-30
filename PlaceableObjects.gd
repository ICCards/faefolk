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
func update_ui_slots(data): 
	if not get_node("../").server_data == {}:
		get_node("../").server_data["ui_slots"][data["id"]] = data["dict"]


@rpc
func update_placeable_health(data): 
	if not get_node("../").world == {}:
		get_node("../").world[data["chunk"]]["placeable"][data["id"]]["h"] = data["health"]
		for node in self.get_children():
			if node.name == data["id"]:
				get_node(str(data["id"])).hit(data)
				return

@rpc
func destroy_placeable_object(data):
	if not get_node("../").world == {}:
		if get_node("../").server_data["ui_slots"].has([data["id"]]): # clear ui slots
				get_node("../").server_data.erase([data["id"]])
		get_node("../").world[data["chunk"]]["placeable"].erase(data["id"])
		for node in self.get_children():
			if node.name == data["id"]:
				get_node(str(data["id"])).destroy(data)
				return

@rpc
func add_new_object_to_world(player_id,type,id,data): 
	if not get_node("../").world == {}:
		if type == "placeable":
			if Util.isCookingItem(data["n"]):
				get_parent().server_data["ui_slots"][id] = {"tr":0,"lo":null}
			else:
				get_parent().server_data["ui_slots"][id] = {}
		if player_id != Server.player_node.name:
			var chunk = MapData.get_chunk_from_location(data["l"])
			get_parent().world[chunk][type][id] = data
			if get_node("../WorldBuilder").current_chunks.has(chunk):
				PlaceObject.place(type,id,data)


@rpc
func change_object_data(data): 
	if not get_node("../").world == {}:
		get_node("../").world[data["chunk"]]["placeable"][data["id"]]["o"] = data["o"]
		for node in self.get_children():
			if node.name == data["id"]:
				node.change(data["o"])
				return
