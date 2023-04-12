extends Node

@rpc
func refresh_crop_and_tree_chunk(chunk, tree_dict, crop_dict, tile_dict):
	get_node("../").world[chunk]["tree"] = tree_dict
	get_node("../").world[chunk]["crop"] = crop_dict
	get_node("../").world[chunk]["tile"] = tile_dict
	for id in get_node("../").world[chunk]["tree"]:
		if get_node("../NatureObjects").has_node(id):
			get_node("../NatureObjects/"+id).refresh_tree_type()
	for id in get_node("../").world[chunk]["crop"]:
		if get_node("../PlaceableObjects").has_node(id):
			get_node("../PlaceableObjects/"+id).refresh_image()
	get_node("../FarmingTiles/WateredTiles").clear()
