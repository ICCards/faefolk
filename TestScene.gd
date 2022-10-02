extends YSort

onready var TreeObject = preload("res://World/Objects/Nature/Trees/TreeObject.tscn")
onready var DesertTreeObject = preload("res://World/Objects/Nature/Trees/DesertTreeObject.tscn")
onready var BranchObject = preload("res://World/Objects/Nature/Trees/TreeBranchObject.tscn")
onready var StumpObject = preload("res://World/Objects/Nature/Trees/TreeStumpObject.tscn")
onready var OreObject = preload("res://World/Objects/Nature/Ores/OreObjectLarge.tscn")
onready var SmallOreObject = preload("res://World/Objects/Nature/Ores/OreObjectSmall.tscn")
onready var TallGrassObject = preload("res://World/Objects/Nature/Grasses/TallGrassObject.tscn")
onready var FlowerObject = preload("res://World/Objects/Nature/Grasses/FlowerObject.tscn")
onready var LoadingScreen = preload("res://MainMenu/LoadingScreen.tscn")
var rng = RandomNumberGenerator.new()

onready var dirt = $GeneratedTiles/DirtTiles
onready var plains = $GeneratedTiles/GreenGrassTiles
onready var forest = $GeneratedTiles/DarkGreenGrassTiles
onready var water = $GeneratedTiles/Water
onready var validTiles = $ValidTiles
onready var hoed = $FarmingTiles/HoedAutoTiles
onready var watered = $FarmingTiles/WateredAutoTiles
onready var snow = $GeneratedTiles/SnowTiles
onready var waves = $GeneratedTiles/WaveTiles
onready var wetSand = $GeneratedTiles/WetSandBeachBorder
onready var sand = $GeneratedTiles/DrySandTiles
onready var shallow_ocean = $GeneratedTiles/ShallowOcean
onready var deep_ocean = $GeneratedTiles/DeepOcean
onready var top_ocean = $GeneratedTiles/TopOcean


var object_types = ["tree", "tree stump", "tree branch", "ore large", "ore small"]
var tall_grass_types = ["dark green", "green", "red", "yellow"]
var treeTypes = ['A','B', 'C', 'D', 'E']
var oreTypes = ["Stone", "Cobblestone"]

func _ready():
	Tiles.valid_tiles = $ValidTiles
	Tiles.hoed_tiles = $FarmingTiles/HoedAutoTiles
	Tiles.ocean_tiles = $GeneratedTiles/ShallowOcean
	Tiles.dirt_tiles = $GeneratedTiles/DirtTiles
	Tiles.wall_tiles = $PlacableTiles/WallTiles
	Tiles.foundation_tiles = $PlacableTiles/FoundationTiles

func build_valid_tiles():
	for x in range(1000):
		for y in range(1000):
			validTiles.set_cellv(Vector2(x+1, y+1), 0)


func wait_for_map():
	if not Server.generated_map.empty():
		buildMap(Server.generated_map)
	else:
		yield(get_tree().create_timer(0.5), "timeout")
		wait_for_map()

func buildMap(map):
	Tiles.valid_tiles = $Navigation2D/ValidTiles
	Tiles.hoed_tiles = $FarmingTiles/HoedAutoTiles
	Tiles.ocean_tiles = $GeneratedTiles/ShallowOcean
	Tiles.dirt_tiles = $GeneratedTiles/DirtTiles
	Tiles.wall_tiles = $PlacableTiles/WallTiles
	Tiles.foundation_tiles = $PlacableTiles/FoundationTiles
	build_valid_tiles()
	print("BUILDING MAP")
	get_node("loadingScreen").set_phase("Building terrain")
	for id in map["dirt"]:
#		var loc = Util.string_to_vector2(map["dirt"][id])
#		var x = loc.x
#		var y = loc.y
#		tile_ids["" + str(x) + "" + str(y)] = id
#		if map["dirt"][id]["isWatered"]:
#			watered.set_cellv(loc, 0)
#			hoed.set_cellv(loc, 0)
#		if map["dirt"][id]["isHoed"]:
#			hoed.set_cellv(loc, 0)
		dirt.set_cellv(map["dirt"][id], 0)
	hoed.update_bitmask_region()
	watered.update_bitmask_region()
	print("LOADED DIRT")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["plains"]:
		var loc = map["plains"][id]
		plains.set_cellv(loc, 0)
	print("LOADED PLAINS")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["forest"]:
		var loc = map["forest"][id]
		forest.set_cellv(loc, 0)
	print("LOADED DG")
	get_node("loadingScreen").set_phase("Building trees")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["snow"]:
		var loc = map["snow"][id]
		snow.set_cellv(loc, 0)
	for id in map["desert"]:
		var loc = map["desert"][id]
		#desert.set_cellv(loc, 0)
		Tiles._set_cell(sand, loc.x, loc.y, 0)
	for id in map["beach"]:
		var loc = map["beach"][id]
		Tiles._set_cell(sand, loc.x, loc.y, 0)
	for id in map["tree"]:
		var loc = map["tree"][id]["l"]
		Tiles.remove_nature_invalid_tiles(loc, "tree")
		var biome = map["tree"][id]["b"]
		if biome == "desert":
			var object = DesertTreeObject.instance()
			object.health = map["tree"][id]["h"]
			object.position = dirt.map_to_world(loc) + Vector2(0, -8)
			object.name = id
			$NatureObjects.add_child(object,true)
		else:
			treeTypes.shuffle()
			var variety = treeTypes.front()
			var object = TreeObject.instance()
			object.biome = biome
			object.health = map["tree"][id]["h"]
			object.initialize(variety, loc)
			object.position = dirt.map_to_world(loc) + Vector2(0, -8)
			object.name = id
			$NatureObjects.add_child(object,true)
	print("LOADED TREES")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["log"]:
		var loc = map["log"][id]["l"]
		Tiles.remove_nature_invalid_tiles(loc, "log")
		var variety = rng.randi_range(0, 11)
		var object = BranchObject.instance()
		object.name = id
		object.health = map["log"][id]["h"]
		object.initialize(variety,loc)
		object.position = dirt.map_to_world(loc) + Vector2(16, 16)
		$NatureObjects.add_child(object,true)
	print("LOADED LOGS")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["stump"]:
		var loc = map["stump"][id]["l"]
		Tiles.remove_nature_invalid_tiles(loc, "stump")
		treeTypes.shuffle()
		var variety = treeTypes.front()
		var object = StumpObject.instance()
		object.health = map["stump"][id]["h"]
		object.name = id
		object.initialize(variety,loc)
		object.position = dirt.map_to_world(loc) + Vector2(4,0)
		$NatureObjects.add_child(object,true)
	print("LOADED STUMPS")
	get_node("loadingScreen").set_phase("Building ore")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["ore_large"]:
		var loc = map["ore_large"][id]["l"]
		Tiles.remove_nature_invalid_tiles(loc, "large ore")
		oreTypes.shuffle()
		var variety = oreTypes.front()
		var object = OreObject.instance()
		object.health = map["ore_large"][id]["h"]
		object.name = id
		object.initialize(variety,loc)
		object.position = dirt.map_to_world(loc) 
		$NatureObjects.add_child(object,true)
	print("LOADED LARGE OrE")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["ore"]:
		var loc = map["ore"][id]["l"]
		Tiles.remove_nature_invalid_tiles(loc, "ore")
		oreTypes.shuffle()
		var variety = oreTypes.front()
		var object = SmallOreObject.instance()
		object.health = map["ore"][id]["h"]
		object.name = id
		object.initialize(variety,loc)
		object.position = dirt.map_to_world(loc) + Vector2(16, 24)
		$NatureObjects.add_child(object,true)
	get_node("loadingScreen").set_phase("Building grass")
	yield(get_tree().create_timer(0.5), "timeout")
	var count = 0
	for id in map["tall_grass"]:
		var loc = map["tall_grass"][id]["l"]
		Tiles.remove_nature_invalid_tiles(loc, "tall grass")
		count += 1
		var object = TallGrassObject.instance()
		object.loc = loc
		object.biome = map["tall_grass"][id]["b"]
		object.name = id
		object.position = dirt.map_to_world(loc) + Vector2(8, 32)
		$NatureObjects.add_child(object,true)
		if count == 130:
			yield(get_tree().create_timer(0.25), "timeout")
			count = 0
	get_node("loadingScreen").set_phase("Building flowers")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["flower"]:
		count += 1
		var loc = map["flower"][id]["l"]
		var object = FlowerObject.instance()
		object.position = dirt.map_to_world(loc) + Vector2(16, 32)
		$NatureObjects.add_child(object,true)
		if count == 130:
			yield(get_tree().create_timer(0.25), "timeout")
			count = 0
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("loadingScreen").set_phase("Generating world")
	#fill_biome_gaps(map)
	#set_water_tiles()
	#check_and_remove_invalid_autotiles(map)
	#yield(get_tree().create_timer(0.5), "timeout")
	#update_tile_bitmask_regions()
	get_node("loadingScreen").set_phase("Spawning in")
	Server.player_state = "WORLD"
	print("Map loaded")
#	yield(get_tree().create_timer(8.5), "timeout")
	get_node("loadingScreen").queue_free()
	#spawnPlayer()
	#spawnPlayerExample()
	Server.isLoaded = true
	Server.world = self
	#spawn_animals()


