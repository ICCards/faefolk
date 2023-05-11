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
@onready var desert: TileMap = get_node("../../TerrainTiles/Desert")
@onready var sand: TileMap = get_node("../../TerrainTiles/Sand")
@onready var shallow_ocean: TileMap = get_node("../../TerrainTiles/ShallowOcean")
@onready var deep_ocean: TileMap = get_node("../../TerrainTiles/DeepOcean")
@onready var top_ocean: TileMap = get_node("../../TerrainTiles/TopOcean")
@onready var top_ocean2: TileMap = get_node("../../TerrainTiles/TopOcean2")


var terrain_thread := Thread.new()
var rng := RandomNumberGenerator.new()

var built_chunks = []
var current_chunks = []

var spawn_loc

var game_state: GameState

func initialize():
	build()
#	build_terrain()
#	$BuildTerrainTimer.start()

func build():
	var terrain = get_node("../../").terrain
	snow.set_cells_terrain_connect(0,terrain["snow"],0,0)
	await get_tree().create_timer(0.25).timeout
	forest.set_cells_terrain_connect(0,terrain["forest"],0,0)
	await get_tree().create_timer(0.25).timeout
	plains.set_cells_terrain_connect(0,terrain["plains"],0,0)
	await get_tree().create_timer(0.25).timeout
	dirt.set_cells_terrain_connect(0,terrain["dirt"],0,0)
	await get_tree().create_timer(0.25).timeout
	wet_sand.set_cells_terrain_connect(0,terrain["wet_sand"],0,0)
	await get_tree().create_timer(0.25).timeout
	waves.set_cells_terrain_connect(0,terrain["ocean"],0,0)
	await get_tree().create_timer(0.25).timeout
	for loc in terrain["ocean"]:
		validTiles.set_cell(0,loc,0,Vector2i(-1,-1))
		shallow_ocean.set_cell(0,loc,0,Vector2i(26,58))
		top_ocean.set_cell(0,loc,0,Vector2i(24,56))
	await get_tree().create_timer(0.25).timeout
	for loc in terrain["deep_ocean"]:
		validTiles.set_cell(0,loc,0,Vector2i(-1,-1))
		deep_ocean.set_cell(0,loc,0,Vector2i(26,56))
		top_ocean2.set_cell(0,loc,0,Vector2i(24,56))
		for adjTile in Constants.randomAdjacentTiles:
			deep_ocean.set_cell(0,loc+adjTile,0,Vector2i(26,56))
			top_ocean2.set_cell(0,loc+adjTile,0,Vector2i(24,56))
	await get_tree().create_timer(0.25).timeout
	for tile in terrain["desert"]:
		desert.set_cell(0,tile,0,Tiles.return_atlas_tile_cord("desert",null))
	await get_tree().create_timer(0.25).timeout
	for tile in terrain["beach"]:
		beach.set_cell(0,tile,0,Tiles.return_atlas_tile_cord("beach",null))


func _on_build_terrain_timer_timeout():
	pass
#	build_terrain()

#func _whoAmI(chunk):
#	call_deferred("spawn_chunk", chunk)
#
#func build_terrain():
#	for new_chunk in get_parent().built_chunks:
#		if not built_chunks.has(new_chunk) and not terrain_thread.is_started():
#			built_chunks.append(new_chunk)
#			terrain_thread.start(Callable(self,"_whoAmI").bind(new_chunk))

#func spawn_chunk(chunk_name):
#	var _chunk
#	_chunk = get_node("../../").world[chunk_name]
#	if _chunk["plains"].keys().size() > 0:
#		for loc in _chunk["plains"].keys():
#			var atlas_cord = Tiles.return_atlas_tile_cord("plains",_chunk["plains"][loc]) #tile[1])
#			plains.set_cell(0,loc,0,atlas_cord)
#		await get_tree().create_timer(0.05).timeout
#	if _chunk["snow"].keys().size() > 0:
#		for loc in _chunk["snow"].keys():
#			var atlas_cord = Tiles.return_atlas_tile_cord("snow",_chunk["snow"][loc]) #tile[1])
#			snow.set_cell(0,loc,0,atlas_cord)
#		await get_tree().create_timer(0.05).timeout
#	if _chunk["forest"].keys().size() > 0:
#		for loc in _chunk["forest"].keys():
#			var atlas_cord = Tiles.return_atlas_tile_cord("forest",_chunk["forest"][loc])
#			forest.set_cell(0,loc,0,atlas_cord)
#		await get_tree().create_timer(0.05).timeout
#	if _chunk["beach"].size() > 0:
#		for tile in _chunk["beach"]:
#			beach.set_cell(0,tile,0,Tiles.return_atlas_tile_cord("beach",null))
#		await get_tree().create_timer(0.05).timeout
#	if _chunk["desert"].size() > 0:
#		for tile in _chunk["desert"]:
#			beach.set_cell(0,tile,0,Tiles.return_atlas_tile_cord("desert",null))
#		await get_tree().create_timer(0.05).timeout
#	if _chunk["dirt"].keys().size() > 0:
#		for loc in _chunk["dirt"].keys():
#			var atlas_cord = Tiles.return_atlas_tile_cord("dirt",_chunk["dirt"][loc]) #tile[1])
#			dirt.set_cell(0,loc,0,atlas_cord)
#		await get_tree().create_timer(0.05).timeout
#	if _chunk["wet_sand"].keys().size() > 0:
#		for loc in _chunk["wet_sand"].keys():
#			var atlas_cord = Tiles.return_atlas_tile_cord("wet_sand",_chunk["wet_sand"][loc])
#			wet_sand.set_cell(0,loc,0,atlas_cord)
#		await get_tree().create_timer(0.05).timeout
#	if _chunk["deep_ocean"].size() > 0:
#		for loc in _chunk["deep_ocean"]:
#			var atlas_cord = Tiles.return_atlas_tile_cord("deep_ocean",0)#_chunk["deep_ocean"][loc])
#			deep_ocean.set_cell(0,loc,0,atlas_cord)
#			for adjTile in Constants.randomAdjacentTiles:
#				if not _chunk["deep_ocean"].has(loc+adjTile):
#					deep_ocean.set_cell(0,loc+adjTile,0,atlas_cord)
#					top_ocean2.set_cell(0,loc+adjTile,0,Vector2i(24,56))
#					validTiles.set_cell(0,loc+adjTile,0,Vector2i(-1,-1))
#			validTiles.set_cell(0,loc,0,Vector2i(-1,-1))
#			top_ocean2.set_cell(0,loc,0,Vector2i(24,56))
#		await get_tree().create_timer(0.05).timeout
#	if _chunk["ocean"].keys().size() > 0:
#		for loc in _chunk["ocean"].keys():
#			var atlas_cord = Tiles.return_atlas_tile_cord("ocean",_chunk["ocean"][loc])
#			validTiles.set_cell(0,loc,0,Constants.NAVIGATION_TILE_ATLAS_CORD)
#			waves.set_cell(0,loc,0,atlas_cord)
#			shallow_ocean.set_cell(0,loc,0,Vector2i(26,58))
#			top_ocean.set_cell(0,loc,0,Vector2i(24,56))
#		await get_tree().create_timer(0.05).timeout
#	terrain_thread.wait_to_finish()
