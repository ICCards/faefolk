extends Node2D


@rpc
func nature_object_hit(peer_id,type,id,loc,tool_name):pass

@rpc
func return_new_nature_health(data):
	print(data["player_id"])
	print(data["type"])
	print(data["id"])
	print(data["chunk"])
	print(data["health"])
	get_parent().nature[data["chunk"]][data["type"]][data["id"]]["h"] = data["health"]
	if get_parent().nature[data["chunk"]][data["type"]][data["id"]]["h"] <= 0:
		get_parent().nature[data["chunk"]][data["type"]].erase([data["id"]])
	if self.get_children().has(data["id"]):
		get_node(data["id"]).hit(data["player_id"],data["health"])
	print("RECEIVED HIT")

