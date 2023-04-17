extends Node2D

@rpc
func remove_object(player_id,type,id,data): pass
@rpc
func player_place_object(player_id,type,id,data): pass


@rpc
func remove_object_from_world(type,id,loc):
	var chunk = MapData.get_chunk_from_location(loc)
	get_parent().world[chunk][type].erase(id)
	for node in self.get_children():
		if node.name == id:
			get_node(id).destroy()
			return


@rpc
func add_new_object_to_world(player_id,type,id,data): 
	if player_id != Server.player_node.name:
		var chunk = MapData.get_chunk_from_location(data["l"])
		get_parent().world[chunk][type][id] = data
		if get_node("../WorldBuilder").current_chunks.has(chunk):
			PlaceObject.place(type,id,data)
