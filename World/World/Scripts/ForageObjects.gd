extends Node2D


@rpc
func forage_object_picked_up(id,loc):pass

@rpc
func destroy_forage_object(data):
	if not get_node("../").world == {}:
		get_node("../").world[data["chunk"]]["forage"].erase(data["id"])
		for node in self.get_children():
			if node.name == data["id"]:
				get_node(str(data["id"])).destroy()
				return
