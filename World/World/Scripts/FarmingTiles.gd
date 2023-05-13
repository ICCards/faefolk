extends Node2D

@onready var hoed_tiles: TileMap = $HoedTiles
@onready var watered_tiles: TileMap = $WateredTiles

@rpc
func set_hoed_tile(loc): pass

@rpc
func set_watered_tile(loc): pass

@rpc
func remove_hoed_tile(loc): pass


@rpc 
func change_tile_in_world(data): 
	var chunk = MapData.get_chunk_from_location(data["l"])
	if data["t"] == "r": # remove
		Server.world.world[chunk].erase(data["l"])
	else:
		Server.world.world[chunk][data["l"]] = data["t"]
	if get_node("../WorldBuilder").current_chunks.has(chunk):
		if data["t"] == "r":
			watered_tiles.set_cells_terrain_connect(0,[data["l"]],0,-1)
			hoed_tiles.set_cells_terrain_connect(0,[data["l"]],0,-1)
		elif data["t"] == "h":
			hoed_tiles.set_cells_terrain_connect(0,[data["l"]],0,0)
		else:
			watered_tiles.set_cells_terrain_connect(0,[data["l"]],0,0)
		
