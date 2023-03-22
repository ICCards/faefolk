extends Node

@onready var dirt: TileMap = get_node("../../TerrainTiles/Dirt")
@onready var plains: TileMap = get_node("../../TerrainTiles/Plains")
@onready var forest: TileMap = get_node("../../TerrainTiles/Forest")
#onready var water = $GeneratedTiles/Water
@onready var validTiles: TileMap = get_node("../../TerrainTiles/ValidTiles") 
#@onready var navTiles = get_node("../../Node2D/NavTiles")
@onready var hoed: TileMap = get_node("../../FarmingTiles/HoedTiles")
@onready var watered: TileMap = get_node("../../FarmingTiles/WateredTiles")
@onready var snow: TileMap = get_node("../../TerrainTiles/Snow")
@onready var waves: TileMap = get_node("../../TerrainTiles/Waves")
@onready var wet_sand: TileMap = get_node("../../TerrainTiles/WetSand")
@onready var beach: TileMap = get_node("../../TerrainTiles/Beach")
@onready var sand: TileMap = get_node("../../TerrainTiles/Sand")
@onready var shallow_ocean: TileMap = get_node("../../TerrainTiles/ShallowOcean")
@onready var deep_ocean: TileMap = get_node("../../TerrainTiles/DeepOcean")
@onready var top_ocean: TileMap = get_node("../../TerrainTiles/TopOcean")


var terrain_thread := Thread.new()
var rng := RandomNumberGenerator.new()

var built_chunks = []
var current_chunks = []

var spawn_loc

var game_state: GameState

func initialize():
	$BuildTerrainTimer.start()

func _on_build_terrain_timer_timeout():
	build_terrain()

func _whoAmI(chunk):
	call_deferred("spawn_chunk", chunk)

func build_terrain():
	if Server.player_node:
		for new_chunk in get_parent().built_chunks:
			if not built_chunks.has(new_chunk) and not terrain_thread.is_started():
				built_chunks.append(new_chunk)
				terrain_thread.start(Callable(self,"_whoAmI").bind(new_chunk))

func spawn_chunk(chunk_name):
	print("SPAWN CHUNK " + str(chunk_name))
	var _chunk
	if chunk_name.length() == 2:
		_chunk = MapData.return_chunk(chunk_name.left(1),chunk_name.right(1))
	else:
		_chunk = MapData.return_chunk(chunk_name.left(1),chunk_name.right(2))
	if _chunk["plains"].size() > 0:
		for tile in _chunk["plains"]:
			var atlas_cord = Tiles.return_atlas_tile_cord("plains",tile[1])
			plains.set_cell(0,tile[0],0,atlas_cord)
		await get_tree().create_timer(0.05).timeout
	if _chunk["snow"].size() > 0:
		for tile in _chunk["snow"]:
			var atlas_cord = Tiles.return_atlas_tile_cord("snow",tile[1])
			snow.set_cell(0,tile[0],0,atlas_cord)
		await get_tree().create_timer(0.05).timeout
	if _chunk["forest"].size() > 0:
		for tile in _chunk["forest"]:
			var atlas_cord = Tiles.return_atlas_tile_cord("forest",tile[1])
			forest.set_cell(0,tile[0],0,atlas_cord)
		#forest.set_cells_terrain_connect(0,_chunk["forest"],0,0)
		await get_tree().create_timer(0.05).timeout
	if _chunk["beach"].size() > 0:
		for tile in _chunk["beach"]:
			beach.set_cell(0,tile,0,Vector2i(rng.randi_range(50,52),rng.randi_range(24,26)))
		await get_tree().create_timer(0.05).timeout
	if _chunk["desert"].size() > 0:
		for tile in _chunk["desert"]:
			beach.set_cell(0,tile,0,Vector2i(rng.randi_range(50,52),rng.randi_range(24,26)))
		await get_tree().create_timer(0.05).timeout
	if _chunk["dirt"].size() > 0:
		for tile in _chunk["dirt"]:
			var atlas_cord = Tiles.return_atlas_tile_cord("dirt",tile[1])
			dirt.set_cell(0,tile[0],0,atlas_cord)
		await get_tree().create_timer(0.05).timeout
	if _chunk["wet_sand"].size() > 0:
		for tile in _chunk["wet_sand"]:
			wet_sand.set_cell(0,tile,0,Vector2i(54,22))
			#wet_sand.set_cells_terrain_connect(0,_chunk["wet_sand"],0,0)
		await get_tree().create_timer(0.05).timeout
	if _chunk["deep_ocean"].size() > 0:
		for tile in _chunk["deep_ocean"]:
			deep_ocean.set_cell(0,tile,0,Vector2i(26,56))
		await get_tree().create_timer(0.05).timeout
	if _chunk["ocean"].size() > 0:
		for tile in _chunk["ocean"]:
#			if wet_sand.get_cell_atlas_coords(0,tile) == Vector2i(-1,-1) and beach.get_cell_atlas_coords(0,tile) == Vector2i(-1,-1):
			#wet_sand.set_cell(0,tile,0,Vector2i(54,22))
			shallow_ocean.set_cell(0,tile,0,Vector2i(26,58))
			top_ocean.set_cell(0,tile,0,Vector2i(24,56))
		await get_tree().create_timer(0.05).timeout
	await get_tree().create_timer(0.05).timeout
#		wet_sand.set_cells_terrain_connect(0,_chunk["ocean"],0,0)
#		for tile in _chunk["ocean"]:
##			if beach.get_cell_atlas_coords(0,tile+Vector2(1,0)) != Vector2i(-1,-1) or beach.get_cell_atlas_coords(0,tile+Vector2(-1,0)) != Vector2i(-1,-1) or \
##			beach.get_cell_atlas_coords(0,tile+Vector2(0,1)) != Vector2i(-1,-1) or beach.get_cell_atlas_coords(0,tile+Vector2(0,-1)) != Vector2i(-1,-1) or \
##			beach.get_cell_atlas_coords(0,tile+Vector2(1,1)) != Vector2i(-1,-1) or beach.get_cell_atlas_coords(0,tile+Vector2(1,-1)) != Vector2i(-1,-1) or \
##			beach.get_cell_atlas_coords(0,tile+Vector2(-1,1)) != Vector2i(-1,-1) or beach.get_cell_atlas_coords(0,tile+Vector2(-1,-1)) != Vector2i(-1,-1):
##				_chunk["ocean"].erase(tile)
##		await get_tree().create_timer(0.25).timeout
#		for tile in _chunk["ocean"]:
#			shallow_ocean.set_cell(0,tile,0,Vector2i(26,58))
#			top_ocean.set_cell(0,tile,0,Vector2i(24,56))
#		wet_sand.set_cells_terrain_connect(0,_chunk["ocean"],0,0)
#		waves.set_cells_terrain_connect(0,_chunk["ocean"],0,0)
#	await get_tree().create_timer(0.25).timeout
	terrain_thread.wait_to_finish()
#			if sand.get_cellv(loc) == -1:
#				wet_sand.set_cellv(loc, 0)
#				waves.set_cellv(loc, 5)
#				shallow_ocean.set_cellv(loc, 0)
#				top_ocean.set_cellv(loc, 0)
#				deep_ocean.set_cellv(loc, 0)
#				validTiles.set_cellv(loc, -1)
#		await get_tree().idle_frame
#	for loc in _chunk["beach"]:
#		#Tiles._set_cell(sand, loc.x, loc.y, 0)
#		for i in range(4):
#			if sand.get_cellv(loc+Vector2(i,0)) != -1 or sand.get_cellv(loc+Vector2(-i,0)) != -1 or sand.get_cellv(loc+Vector2(0,i)) != -1 or sand.get_cellv(loc+Vector2(0,-i)) != -1:
#				shallow_ocean.set_cellv(loc+Vector2(i,0),-1)
#				top_ocean.set_cellv(loc+Vector2(i,0),-1)
#				deep_ocean.set_cellv(loc+Vector2(i,0),-1)
#				waves.set_cellv(loc+Vector2(i,0), -1)
#				shallow_ocean.set_cellv(loc+Vector2(-i,0),-1)
#				top_ocean.set_cellv(loc+Vector2(-i,0),-1)
#				deep_ocean.set_cellv(loc+Vector2(-i,0),-1)
#				waves.set_cellv(loc+Vector2(-i,0), -1)
#				shallow_ocean.set_cellv(loc+Vector2(0,i),-1)
#				top_ocean.set_cellv(loc+Vector2(0,i),-1)
#				deep_ocean.set_cellv(loc+Vector2(0,i),-1)
#				waves.set_cellv(loc+Vector2(0,i), -1)
#				shallow_ocean.set_cellv(loc+Vector2(0,-i),-1)
#				top_ocean.set_cellv(loc+Vector2(0,-i),-1)
#				deep_ocean.set_cellv(loc+Vector2(0,-i),-1)
#				waves.set_cellv(loc+Vector2(0,-i), -1)
#		for i in range(4):
#			i += 4
#			if sand.get_cellv(loc+Vector2(i,0)) != -1 or sand.get_cellv(loc+Vector2(-i,0)) != -1 or \
#			sand.get_cellv(loc+Vector2(0,i)) != -1 or sand.get_cellv(loc+Vector2(0,-i)) != -1 or \
#			sand.get_cellv(loc+Vector2(i,i)) != -1 or sand.get_cellv(loc+Vector2(-i,i)) != -1 or \
#			sand.get_cellv(loc+Vector2(i,-i)) != -1 or sand.get_cellv(loc+Vector2(-i,-i)) != -1:
#				deep_ocean.set_cellv(loc+Vector2(i,0),-1)
#				deep_ocean.set_cellv(loc+Vector2(-i,0),-1)
#				deep_ocean.set_cellv(loc+Vector2(0,i),-1)
#				deep_ocean.set_cellv(loc+Vector2(0,-i),-1)
#	await get_tree().process_frame
#	call_deferred("update_bitmasks", chunk_name)
