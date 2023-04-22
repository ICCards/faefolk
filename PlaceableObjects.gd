extends Node2D

@rpc
func player_remove_object(player_id,type,id,data): pass

@rpc
func player_place_object(player_id,type,id,data): pass

@rpc
func placeable_object_hit(peer_id,id,loc,tool_name):pass

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
		if get_node("../").server_data.has([data["id"]]): # clear ui slots
			get_node("../").server_data.erase([data["id"]])
		get_node("../").world[data["chunk"]]["placeable"].erase(data["id"])
		for node in self.get_children():
			if node.name == data["id"]:
				get_node(str(data["id"])).destroy(data)
				return

@rpc
func add_new_object_to_world(player_id,type,id,data): 
	if not get_node("../").world == {}:
		if player_id != Server.player_node.name:
			var chunk = MapData.get_chunk_from_location(data["l"])
			get_parent().world[chunk][type][id] = data
			if get_node("../WorldBuilder").current_chunks.has(chunk):
				PlaceObject.place(type,id,data)
