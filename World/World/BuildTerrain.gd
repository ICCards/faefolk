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
	build_terrain()
	$BuildTerrainTimer.start()

func _on_build_terrain_timer_timeout():
	build_terrain()

func _whoAmI(chunk):
	call_deferred("spawn_chunk", chunk)

func build_terrain():
#	for column in range(12):
#		for row in ["A","B","C","D","E","F","G","H","I","J","K","L"]:
#			spawn_chunk(row+str(column+1))
	for new_chunk in get_parent().built_chunks:
		if not built_chunks.has(new_chunk) and not terrain_thread.is_started():
			built_chunks.append(new_chunk)
			terrain_thread.start(Callable(self,"_whoAmI").bind(new_chunk))

func spawn_chunk(chunk_name):
	print("SPAWN CHUNK " + str(chunk_name))
	var _chunk = MapData.world[chunk_name]
	if _chunk["plains"].size() > 0:
		for tile in _chunk["plains"]:
			var atlas_cord = Tiles.return_atlas_tile_cord("plains",0)#tile[1])
			plains.set_cell(0,tile,0,atlas_cord)
		await get_tree().create_timer(0.05).timeout
	if _chunk["snow"].size() > 0:
		for tile in _chunk["snow"]:
			var atlas_cord = Tiles.return_atlas_tile_cord("snow",0)#tile[1])
			snow.set_cell(0,tile,0,atlas_cord)
		await get_tree().create_timer(0.05).timeout
	if _chunk["forest"].size() > 0:
		for tile in _chunk["forest"]:
			var atlas_cord = Tiles.return_atlas_tile_cord("forest",0)#tile[1])
			forest.set_cell(0,tile,0,atlas_cord)
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
			var atlas_cord = Tiles.return_atlas_tile_cord("dirt",0)#tile[1])
			dirt.set_cell(0,tile,0,atlas_cord)
		await get_tree().create_timer(0.05).timeout
	if _chunk["wet_sand"].size() > 0:
		for tile in _chunk["wet_sand"]:
			var atlas_cord = Tiles.return_atlas_tile_cord("wet_sand",0)
			wet_sand.set_cell(0,tile,0,atlas_cord)
		await get_tree().create_timer(0.05).timeout
	if _chunk["deep_ocean"].size() > 0:
		for tile in _chunk["deep_ocean"]:
			var atlas_cord = Tiles.return_atlas_tile_cord("deep_ocean",0)
			deep_ocean.set_cell(0,tile,0,atlas_cord)
			validTiles.set_cell(0,tile,0,Vector2i(-1,-1))
			if tile[1] == 0:
				top_ocean.set_cell(0,tile,0,Vector2i(24,56))
		await get_tree().create_timer(0.05).timeout
	if _chunk["ocean"].size() > 0:
		for tile in _chunk["ocean"]:
			var atlas_cord = Tiles.return_atlas_tile_cord("deep_ocean",0)
			validTiles.set_cell(0,tile,0,Constants.NAVIGATION_TILE_ATLAS_CORD)
			waves.set_cell(0,tile,0,atlas_cord)
			#wet_sand.set_cell(0,tile,0,Vector2i(54,22))
			shallow_ocean.set_cell(0,tile,0,Vector2i(26,58))
			top_ocean.set_cell(0,tile,0,Vector2i(24,56))
		await get_tree().create_timer(0.05).timeout
	await get_tree().create_timer(0.05).timeout
	terrain_thread.wait_to_finish()
