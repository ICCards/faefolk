extends Node2D

@rpc
func weed_hit(id,loc): pass
@rpc
func front_tall_grass_hit(player_id,id,loc): pass
@rpc
func back_tall_grass_hit(player_id,id,loc): pass


@rpc 
func erase_tall_grass(data):
	get_node("../").world[data["chunk"]]["tall_grass"].erase([data["id"]])

@rpc
func destroy_weed(data): 
	get_node("../").world[data["chunk"]]["tall_grass"].erase(data["id"])
	for node in self.get_children():
		if node.name == data["id"]:
			get_node(str(data["id"])).destroy(data)
			return

@rpc
func update_back_tall_grass(data): 
	get_node("../").world[data["chunk"]]["tall_grass"][data["id"]]["bh"] = data["bh"]
	for node in self.get_children():
		if node.name == data["id"]:
			get_node(str(data["id"])).back_hit(data)
			return

@rpc
func update_front_tall_grass(data): 
	get_node("../").world[data["chunk"]]["tall_grass"][data["id"]]["fh"] = data["fh"]
	for node in self.get_children():
		if node.name == data["id"]:
			get_node(str(data["id"])).front_hit(data)
			return

