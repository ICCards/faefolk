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

@rpc 
func set_new_time(minutes, hours):
	if not get_node("../").server_data == {}:
		get_node("../").server_data["time_minutes"] = minutes
		get_node("../").server_data["time_hours"] = hours
		PlayerData.emit_signal("set_time")
		if get_parent().server_data["time_hours"] == 6 and get_parent().server_data["time_minutes"] == 0:
			PlayerData.emit_signal("set_sunrise")
		elif get_parent().server_data["time_hours"] == 22 and get_parent().server_data["time_minutes"] == 0:
			PlayerData.emit_signal("set_sunset")

@rpc 
func set_new_day(day_number, day_week):
	if not get_node("../").server_data == {}:
		get_node("../").server_data["day_number"] = day_number
		get_node("../").server_data["day_week"] = day_week
		PlayerData.emit_signal("set_day")
	
@rpc 
func set_new_season(season):
	if not get_node("../").server_data == {}:
		get_node("../").server_data["day_number"] = 1
		get_node("../").server_data["season"] = season
		PlayerData.emit_signal("set_season")
