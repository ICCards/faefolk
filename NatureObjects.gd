extends Node2D


@rpc
func nature_object_hit(peer_id,type,id,loc,tool_name):pass

@rpc
func update_nature_health(data):
	if not get_node("../").world == {}:
		get_node("../").world[data["chunk"]][data["type"]][data["id"]]["h"] = data["health"]
		for node in self.get_children():
			if node.name == data["id"]:
				get_node(str(data["id"])).hit(data)
				return

@rpc
func destroy_nature_object(data):
	if not get_node("../").world == {}:
		get_node("../").world[data["chunk"]][data["type"]].erase(data["id"])
		for node in self.get_children():
			if node.name == data["id"]:
				get_node(str(data["id"])).destroy(data)
				return
