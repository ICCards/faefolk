extends YSort

onready var dirt = $GeneratedTiles/DirtTiles
onready var plains = $GeneratedTiles/GreenGrassTiles
onready var forest = $GeneratedTiles/DarkGreenGrassTiles
onready var water = $GeneratedTiles/Water
onready var validTiles = $ValidTiles
onready var navTiles = $Navigation2D/NavTiles
onready var hoed = $FarmingTiles/HoedAutoTiles
onready var watered = $FarmingTiles/WateredAutoTiles
onready var snow = $GeneratedTiles/SnowTiles
onready var waves = $GeneratedTiles/WaveTiles
onready var wetSand = $GeneratedTiles/WetSandBeachBorder
onready var sand = $GeneratedTiles/DrySandTiles
onready var shallow_ocean = $GeneratedTiles/ShallowOcean
onready var deep_ocean = $GeneratedTiles/DeepOcean
onready var top_ocean = $GeneratedTiles/TopOcean
onready var Players = $Players

onready var Input_controller_template = preload("res://World/Player/PlayerTemplate/InputControllerTemplate.tscn")
onready var Input_controller = preload("res://World/Player/Player/InputController.tscn")
onready var Player = preload("res://World/Player/Player/Player.tscn")
onready var Player_template = preload("res://World/Player/PlayerTemplate/PlayerTemplate.tscn")
onready var Player_pet = preload("res://World/Player/Pet/PlayerPet.tscn")
onready var Bear = preload("res://World/Animals/Bear.tscn")
onready var Snake = preload("res://World/Animals/Snake.tscn")
onready var IC_Ghost = preload("res://World/Enemies/ICGhost.tscn")
onready var Bunny = preload("res://World/Animals/Bunny.tscn")
onready var Duck = preload("res://World/Animals/Duck.tscn")
onready var Boar = preload("res://World/Animals/Boar.tscn")
onready var Deer = preload("res://World/Animals/Deer.tscn")
onready var Clam = preload("res://World/Objects/Nature/Forage/Clam.tscn")
onready var Starfish = preload("res://World/Objects/Nature/Forage/Starfish.tscn")
onready var WateringCanEffect = preload("res://World/Objects/Nature/Effects/WateringCan.tscn")
onready var HoedDirtEffect = preload("res://World/Objects/Nature/Effects/HoedDirt.tscn") 
onready var DirtTrailEffect = preload("res://World/Objects/Nature/Effects/DustTrailEffect.tscn")
onready var UpgradeBuildingEffect = preload("res://World/Objects/Nature/Effects/UpgradeBuilding.tscn")
onready var RemoveBuildingEffect = preload("res://World/Objects/Nature/Effects/RemoveBuilding.tscn")


onready var TreeObject = preload("res://World/Objects/Nature/Trees/TreeObject.tscn")
onready var DesertTree = preload("res://World/Objects/Nature/Trees/DesertTree.tscn")
onready var Log = preload("res://World/Objects/Nature/Trees/Log.tscn")
onready var Stump = preload("res://World/Objects/Nature/Trees/Stump.tscn")
onready var LargeOre = preload("res://World/Objects/Nature/Ores/LargeOre.tscn")
onready var SmallOre = preload("res://World/Objects/Nature/Ores/SmallOre.tscn")
onready var TallGrass = preload("res://World/Objects/Nature/Grasses/TallGrass.tscn")
onready var Weed = preload("res://World/Objects/Nature/Grasses/Weed.tscn")
onready var Flower = preload("res://World/Objects/Nature/Forage/Flower.tscn")
onready var LoadingScreen = preload("res://MainMenu/LoadingScreen.tscn")
var rng = RandomNumberGenerator.new()

var object_types = ["tree", "tree stump", "tree branch", "ore large", "ore small"]
var tall_grass_types = ["dark green", "green", "red", "yellow"]
var treeTypes = ['A','B', 'C', 'D', 'E']
var oreTypes = ["stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "bronze ore", "iron ore", "bronze ore", "iron ore", "gold ore"]


var object_name
var position_of_object
var object_variety
var day_num = 1
var season = "spring"
var valid_spawn_position
var random_rain_storm_position
var random_snow_storm_position

const NUM_DUCKS = 100
const NUM_BUNNIES = 100
const NUM_BEARS = 20
const NUM_BOARS = 0
const NUM_DEER = 0

const _character = preload("res://Global/Data/Characters.gd")

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 30
var mark_for_despawn = []
var tile_ids = {}

var tall_grass_locs = []

func _ready():
	rng.randomize()
	var loadingScreen = LoadingScreen.instance()
	loadingScreen.name = "loadingScreen"
	add_child(loadingScreen)
	get_node("loadingScreen").set_phase("Getting map")
	yield(get_tree().create_timer(1), "timeout")
	Server.generated_map.clear()
	Server.generate_map()
	wait_for_map()



func wait_for_map():
	if not Server.generated_map.empty():
		buildMap(Server.generated_map)
	else:
		yield(get_tree().create_timer(0.5), "timeout")
		wait_for_map()

#func spawnPlayer():
#	print('gettiing player')
#	print(Server.player)
#	if not Server.player.empty():
#		print("My Character")
#		print(Server.player["c"])
#		var player = Player.instance()
#		print(str(Server.player["p"]))
#		#player.initialize_camera_limits(Vector2(-64,-160), Vector2(9664, 9664))
#		player.name = Server.player_id
#		player.principal = Server.player["principal"]
#		player.character = _character.new()
#		player.character.LoadPlayerCharacter(Server.player["c"])
#		$Players.add_child(player)
#		if Server.player_house_position == null:
#			print("setting position")
#			player.position = dirt.map_to_world(Util.string_to_vector2(Server.player["p"]))
#		else: 
#			player.position = dirt.map_to_world(Server.player_house_position) + Vector2(135, 60)
		
#func spawnPlayerExample(pos):
#	var player = Player.instance()
#	#player.initialize_camera_limits(Vector2(-64,-160), Vector2(96640, 96640))
#	player.name = Server.player_id
#	player.character = _character.new()
#	player.character.LoadPlayerCharacter(Server.character)
#	$Players.add_child(player)
#	if Server.player_house_position == null:
#		var loc = Util.string_to_vector2(pos)
#		player.position = loc * 32
#		#spawn_IC_Ghost(loc)
#		#spawnRandomBear(loc)
#	else: 
#		player.position = dirt.map_to_world(Server.player_house_position) + Vector2(135, 60)
#	#spawn_IC_kitty()
	
func spawnPlayerExample():
	var controller = Input_controller.instance()
	var player = controller.get_children()[0]
	controller.name = str(get_tree().get_network_unique_id())
	player.name = str(get_tree().get_network_unique_id())
	player.character = _character.new()
	#player.character.LoadPlayerCharacter(Server.player["c"])
	player.character.LoadPlayerCharacter("human_male")
	$Players.add_child(controller)
	player.spawn_position = Server.player["p"]
	player.position = Server.player["p"]


func DespawnPlayer(player_id):
	mark_for_despawn.append(player_id)
	if has_node(str(player_id)):
		#yield(get_tree().create_timer(0.5), "timeout")
#		for buffer in world_state_buffer:
#			buffer.erase(player_id)
		var player = get_node(str(player_id))
		remove_child(player)
		player.queue_free()
	
	
func buildMap(map):
	Tiles.valid_tiles = $ValidTiles
	Tiles.hoed_tiles = $FarmingTiles/HoedAutoTiles
	Tiles.watered_tiles = $FarmingTiles/WateredAutoTiles
	Tiles.ocean_tiles = $GeneratedTiles/ShallowOcean
	Tiles.deep_ocean_tiles = $GeneratedTiles/DeepOcean
	Tiles.dirt_tiles = $GeneratedTiles/DirtTiles
	Tiles.wall_tiles = $PlacableTiles/WallTiles
	Tiles.selected_wall_tiles = $PlacableTiles/SelectedWallTiles
	Tiles.foundation_tiles = $PlacableTiles/FoundationTiles
	Tiles.selected_foundation_tiles = $PlacableTiles/SelectedFoundationTiles
	Tiles.object_tiles = $PlacableTiles/ObjectTiles
	Tiles.fence_tiles = $PlacableTiles/FenceTiles
	Tiles.light_tiles = $PlacableTiles/LightTiles
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
#	for id in map["tree"]:
#		var loc = map["tree"][id]["l"] + Vector2(1,0)
#		add_to_quadrant("tree", loc)
#		Tiles.remove_nature_invalid_tiles(loc, "tree")
#		var biome = map["tree"][id]["b"]
#		if biome == "desert":
#			var object = DesertTree.instance()
#			var pos = dirt.map_to_world(loc)
#			object.health = 100
#			object.position = pos + Vector2(0, -8)
#			object.name = id
#			$NatureObjects.add_child(object,true)
#		else:
#			treeTypes.shuffle()
#			var object = TreeObject.instance()
#			var pos = dirt.map_to_world(loc)
#			object.biome = biome
#			object.health = Stats.TREE_HEALTH
#			object.variety = treeTypes.front()
#			object.location = loc
#			object.position = pos + Vector2(0, -8)
#			object.name = id
#			$NatureObjects.add_child(object,true)
#	print("LOADED TREES")
#	yield(get_tree().create_timer(0.5), "timeout")
##	for id in map["log"]:
#		var loc = map["log"][id]["l"] + Vector2(1,0)
##		Tiles.remove_nature_invalid_tiles(loc, "log")
##		var variety = rng.randi_range(0, 11)
##		var object = Log.instance()
##		object.name = id
##		object.variety = variety
##		object.location = loc
##		object.position = dirt.map_to_world(loc) + Vector2(16, 16)
##		$NatureObjects.add_child(object,true)
#	print("LOADED LOGS")
#	yield(get_tree().create_timer(0.5), "timeout")
#	for id in map["stump"]:
#		var loc = map["stump"][id]["l"] + Vector2(1,0)
##		Tiles.remove_nature_invalid_tiles(loc, "stump")
##		treeTypes.shuffle()
##		var object = Stump.instance()
##		object.variety = treeTypes.front()
##		object.location = loc
##		object.health = Stats.STUMP_HEALTH
##		object.name = id
##		object.position = dirt.map_to_world(loc) + Vector2(4,0)
##		$NatureObjects.add_child(object,true)
#	print("LOADED STUMPS")
#	get_node("loadingScreen").set_phase("Building ore")
#	yield(get_tree().create_timer(0.5), "timeout")
#	for id in map["ore_large"]:
#		var loc = map["ore_large"][id]["l"]
#		Tiles.remove_nature_invalid_tiles(loc, "large ore")
#		oreTypes.shuffle()
#		var object = LargeOre.instance()
#		object.health = Stats.LARGE_ORE_HEALTH
#		object.name = id
#		object.variety = oreTypes.front()
#		object.location = loc
#		object.position = dirt.map_to_world(loc) 
#		$NatureObjects.add_child(object,true)
#	print("LOADED LARGE OrE")
#	yield(get_tree().create_timer(0.5), "timeout")
#	for id in map["ore"]:
#		var loc = map["ore"][id]["l"]
#		Tiles.remove_nature_invalid_tiles(loc, "ore")
#		oreTypes.shuffle()
#		var object = SmallOre.instance()
#		object.health = Stats.SMALL_ORE_HEALTH
#		object.name = id
#		object.variety = oreTypes.front()
#		object.location = loc
#		object.position = dirt.map_to_world(loc) + Vector2(16, 24)
#		$NatureObjects.add_child(object,true)
#	get_node("loadingScreen").set_phase("Building grass")
#	yield(get_tree().create_timer(0.5), "timeout")
#	var count = 0
#	for id in map["tall_grass"]:
#		var loc = map["tall_grass"][id]["l"]
#		tall_grass_locs.append(loc)
#		if validTiles.get_cellv(loc) != -1:
#			Tiles.remove_nature_invalid_tiles(loc, "tall grass")
#			count += 1
#			var object = TallGrass.instance()
#			object.loc = loc
#			object.biome = map["tall_grass"][id]["b"]
#			object.name = id
#			object.position = dirt.map_to_world(loc) + Vector2(8, 32)
#			$NatureObjects.add_child(object,true)
#			if count == 130:
#				yield(get_tree().create_timer(0.25), "timeout")
#				count = 0
#	get_node("loadingScreen").set_phase("Building flowers")
#	yield(get_tree().create_timer(0.5), "timeout")
#	for id in map["flower"]:
#		var loc = map["flower"][id]["l"]
#		if validTiles.get_cellv(loc) != -1:
#			if Util.chance(50):
#				var object = Weed.instance()
#				object.location = loc
#				object.position = dirt.map_to_world(loc) + Vector2(16, 32)
#				$NatureObjects.add_child(object,true)
#			else:
#				var object = Flower.instance()
#				object.location = loc
#				object.position = dirt.map_to_world(loc)
#				$NatureObjects.add_child(object,true)
#			Tiles.remove_nature_invalid_tiles(loc, "flower")
#			count += 1
#			if count == 130:
#				yield(get_tree().create_timer(0.25), "timeout")
#				count = 0
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("loadingScreen").set_phase("Generating world")
	fill_biome_gaps(map)
	set_water_tiles()
	check_and_remove_invalid_autotiles(map)
	yield(get_tree().create_timer(0.5), "timeout")
	update_tile_bitmask_regions()
	get_node("loadingScreen").set_phase("Spawning in")
	Server.player_state = "WORLD"
	print("Map loaded")
	yield(get_tree().create_timer(8.5), "timeout")
	get_node("loadingScreen").queue_free()
	#spawnPlayer()
	spawnPlayerExample()
	Server.isLoaded = true
	Server.world = self
	#spawn_animals()
	set_random_beach_forage()
	set_nature_object_quadrants()
	set_nav()
	

var b2 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b3 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b4 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b5 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b6 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b7 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c2 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c3 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c4 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c5 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c6 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c7 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d2 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d3 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d4 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d5 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d6 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d7 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e2 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e3 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e4 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e5 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e6 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e7 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f2 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f3 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f4 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f5 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f6 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f7 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g2 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g3 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g4 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g5 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g6 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g7 = {
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}

var player_quadrant

func set_nature_object_quadrants():
	for id in Server.generated_map["tree"]:
		var loc = Server.generated_map["tree"][id]["l"]
		add_to_quadrant("tree", loc, id)
	for id in Server.generated_map["stump"]:
		var loc = Server.generated_map["stump"][id]["l"]
		add_to_quadrant("stump", loc, id)
	for id in Server.generated_map["log"]:
		var loc = Server.generated_map["log"][id]["l"]
		add_to_quadrant("log", loc, id)
	for id in Server.generated_map["ore"]:
		var loc = Server.generated_map["ore"][id]["l"]
		add_to_quadrant("ore", loc, id)
	for id in Server.generated_map["ore_large"]:
		var loc = Server.generated_map["ore_large"][id]["l"]
		add_to_quadrant("ore_large", loc, id)
	for id in Server.generated_map["flower"]:
		var loc = Server.generated_map["flower"][id]["l"]
		add_to_quadrant("flower", loc, id)
	for id in Server.generated_map["flower"]:
		var loc = Server.generated_map["flower"][id]["l"]
		add_to_quadrant("flower", loc, id)
	for id in Server.generated_map["tall_grass"]:
		var loc = Server.generated_map["tall_grass"][id]["l"]
		add_to_quadrant("tall_grass", loc, id)


func add_to_quadrant(type, loc, id):
	var column
	var row
	if loc.x < 250:
		column = 2
	elif loc.x < 375:
		column = 3
	elif loc.x < 500:
		column = 4
	elif loc.x < 625:
		column = 5
	elif loc.x < 750:
		column = 6
	elif loc.x < 1000:
		column = 7
	if loc.y < 250:
		row = "B"
	elif loc.y < 375:
		row = "C"
	elif loc.y < 500:
		row = "D"
	elif loc.y < 625:
		row = "E"
	elif loc.y < 750:
		row = "F"
	elif loc.y < 1000:
		row = "G"
	var chunk = row+str(column)
	match chunk:
		"B2":
			b2[type][id] = Server.generated_map[type][id]
		"B3":
			b3[type][id] = Server.generated_map[type][id]
		"B4":
			b4[type][id] = Server.generated_map[type][id]
		"B5":
			b5[type][id] = Server.generated_map[type][id]
		"B6":
			b6[type][id] = Server.generated_map[type][id]
		"B7":
			b7[type][id] = Server.generated_map[type][id]
		"C2":
			c2[type][id] = Server.generated_map[type][id]
		"C3":
			c3[type][id] = Server.generated_map[type][id]
		"C4":
			c4[type][id] = Server.generated_map[type][id]
		"C5":
			c5[type][id] = Server.generated_map[type][id]
		"C6":
			c6[type][id] = Server.generated_map[type][id]
		"C7":
			c7[type][id] = Server.generated_map[type][id]
		"D2":
			d2[type][id] = Server.generated_map[type][id]
		"D3":
			d3[type][id] = Server.generated_map[type][id]
		"D4":
			d4[type][id] = Server.generated_map[type][id]
		"D5":
			d5[type][id] = Server.generated_map[type][id]
		"D6":
			d6[type][id] = Server.generated_map[type][id]
		"D7":
			d7[type][id] = Server.generated_map[type][id]
		"E2":
			e2[type][id] = Server.generated_map[type][id]
		"E3":
			e3[type][id] = Server.generated_map[type][id]
		"E4":
			e4[type][id] = Server.generated_map[type][id]
		"E5":
			e5[type][id] = Server.generated_map[type][id]
		"E6":
			e6[type][id] = Server.generated_map[type][id]
		"E7":
			e7[type][id] = Server.generated_map[type][id]
		"F2":
			f2[type][id] = Server.generated_map[type][id]
		"F3":
			f3[type][id] = Server.generated_map[type][id]
		"F4":
			f4[type][id] = Server.generated_map[type][id]
		"F5":
			f5[type][id] = Server.generated_map[type][id]
		"F6":
			f6[type][id] = Server.generated_map[type][id]
		"F7":
			f7[type][id] = Server.generated_map[type][id]
		"G2":
			g2[type][id] = Server.generated_map[type][id]
		"G3":
			g3[type][id] = Server.generated_map[type][id]
		"G4":
			g4[type][id] = Server.generated_map[type][id]
		"G5":
			g5[type][id] = Server.generated_map[type][id]
		"G6":
			g6[type][id] = Server.generated_map[type][id]
		"G7":
			g7[type][id] = Server.generated_map[type][id]



var current_chunks = []
func set_player_quadrant(loc):
	var columns
	var rows
	var new_chunks = []
	if loc.x < 312.5:
		columns = [2,3]
	elif loc.x < 437.5:
		columns = [3,4]
	elif loc.x < 562.5:
		columns = [4,5]
	elif loc.x < 687.5:
		columns = [5,6]
	else:
		columns = [6, 7]
	if loc.y < 312.5:
		rows = ["B","C"]
	elif loc.y < 437.5:
		rows = ["C","D"]
	elif loc.y < 562.5:
		rows = ["D","E"]
	elif loc.y < 687.5:
		rows = ["E","F"]
	else:
		rows = ["F","G"]
	for column in columns:
		for row in rows:
			new_chunks.append(row+str(column))
	if new_chunks == current_chunks:
		return
	for current_chunk in current_chunks:
		if not new_chunks.has(current_chunk):
			remove_chunk(return_chunk(current_chunk[0],current_chunk[1]))
	for new_chunk in new_chunks:
		if not current_chunks.has(new_chunk):
			spawn_nature(return_chunk(new_chunk[0],new_chunk[1]))
	current_chunks = new_chunks



func return_chunk(_row, _col):
	_col = int(_col)
	match _row:
		"B":
			match _col:
				2:
					return b2
				3:
					return b3
				4:
					return b4
				5:
					return b5
				6:
					return b6
				7:
					return b7
		"C":
			match _col:
				2:
					return c2
				3:
					return c3
				4:
					return c4
				5:
					return c5
				6:
					return c6
				7:
					return c7
		"D":
			match _col:
				2:
					return d2
				3:
					return d3
				4:
					return d4
				5:
					return d5
				6:
					return d6
				7:
					return d7
		"E":
			match _col:
				2:
					return e2
				3:
					return e3
				4:
					return e4
				5:
					return e5
				6:
					return e6
				7:
					return e7
		"F":
			match _col:
				2:
					return f2
				3:
					return f3
				4:
					return f4
				5:
					return f5
				6:
					return f6
				7:
					return f7
		"G":
			match _col:
				2:
					return g2
				3:
					return g3
				4:
					return g4
				5:
					return g5
				6:
					return g6
				7:
					return g7


func remove_chunk(map):
	print("REMOVING NATURE")
	for id in map["tree"]:
		remove_object(id)
	yield(get_tree().create_timer(0.25), "timeout")
	for id in map["stump"]:
		remove_object(id)
	yield(get_tree().create_timer(0.25), "timeout")
	for id in map["log"]:
		remove_object(id)
	yield(get_tree().create_timer(0.25), "timeout")
	for id in map["ore"]:
		remove_object(id)
	yield(get_tree().create_timer(0.25), "timeout")
	for id in map["ore_large"]:
		remove_object(id)
	yield(get_tree().create_timer(0.25), "timeout")
	for id in map["tall_grass"]:
		remove_object(id)
	yield(get_tree().create_timer(0.25), "timeout")
	for id in map["flower"]:
		remove_object(id)
	print("REMOVED NATURE")

func remove_object(id):
	if $NatureObjects.has_node(id):
		$NatureObjects.get_node(id).queue_free()
		yield(get_tree().create_timer(0.1), "timeout")

func spawn_nature(map):
	print("SPAWNING CHUNK")
	for id in map["tree"]:
		if not $NatureObjects.has_node(id):
			var loc = map["tree"][id]["l"] + Vector2(1,0)
			Tiles.remove_nature_invalid_tiles(loc, "tree")
			var biome = map["tree"][id]["b"]
			if biome == "desert":
				var object = DesertTree.instance()
				var pos = dirt.map_to_world(loc)
				object.health = 100
				object.position = pos + Vector2(0, -8)
				object.name = id
				$NatureObjects.add_child(object,true)
			else:
				treeTypes.shuffle()
				var object = TreeObject.instance()
				var pos = dirt.map_to_world(loc)
				object.biome = biome
				object.health = Stats.TREE_HEALTH
				object.variety = treeTypes.front()
				object.location = loc
				object.position = pos + Vector2(0, -8)
				object.name = id
				$NatureObjects.add_child(object,true)
			yield(get_tree().create_timer(0.11), "timeout")
	yield(get_tree().create_timer(1.5), "timeout")
	for id in map["log"]:
		if not $NatureObjects.has_node(id):
			var loc = map["log"][id]["l"] + Vector2(1,0)
			Tiles.remove_nature_invalid_tiles(loc, "log")
			var variety = rng.randi_range(0, 11)
			var object = Log.instance()
			object.name = id
			object.variety = variety
			object.location = loc
			object.position = dirt.map_to_world(loc) + Vector2(16, 16)
			$NatureObjects.add_child(object,true)
			yield(get_tree().create_timer(0.01), "timeout")
	yield(get_tree().create_timer(1.5), "timeout")
	for id in map["stump"]:
		if not $NatureObjects.has_node(id):
			var loc = map["stump"][id]["l"] + Vector2(1,0)
			Tiles.remove_nature_invalid_tiles(loc, "stump")
			treeTypes.shuffle()
			var object = Stump.instance()
			object.variety = treeTypes.front()
			object.location = loc
			object.health = Stats.STUMP_HEALTH
			object.name = id
			object.position = dirt.map_to_world(loc) + Vector2(4,0)
			$NatureObjects.add_child(object,true)
			yield(get_tree().create_timer(0.01), "timeout")
	yield(get_tree().create_timer(1.5), "timeout")
	for id in map["ore_large"]:
		if not $NatureObjects.has_node(id):
			var loc = map["ore_large"][id]["l"]
			Tiles.remove_nature_invalid_tiles(loc, "large ore")
			oreTypes.shuffle()
			var object = LargeOre.instance()
			object.health = Stats.LARGE_ORE_HEALTH
			object.name = id
			object.variety = oreTypes.front()
			object.location = loc
			object.position = dirt.map_to_world(loc) 
			$NatureObjects.add_child(object,true)
			yield(get_tree().create_timer(0.01), "timeout")
	yield(get_tree().create_timer(1.5), "timeout")
	for id in map["ore"]:
		if not $NatureObjects.has_node(id):
			var loc = map["ore"][id]["l"]
			Tiles.remove_nature_invalid_tiles(loc, "ore")
			oreTypes.shuffle()
			var object = SmallOre.instance()
			object.health = Stats.SMALL_ORE_HEALTH
			object.name = id
			object.variety = oreTypes.front()
			object.location = loc
			object.position = dirt.map_to_world(loc) + Vector2(16, 24)
			$NatureObjects.add_child(object,true)
			yield(get_tree().create_timer(0.01), "timeout")
	yield(get_tree().create_timer(1.5), "timeout")
	var count = 0
	for id in map["tall_grass"]:
		if not $NatureObjects.has_node(id):
			var loc = map["tall_grass"][id]["l"]
			if validTiles.get_cellv(loc) != -1:
				Tiles.remove_nature_invalid_tiles(loc, "tall grass")
				count += 1
				var object = TallGrass.instance()
				object.loc = loc
				object.biome = map["tall_grass"][id]["b"]
				object.name = id
				object.position = dirt.map_to_world(loc) + Vector2(8, 32)
				$NatureObjects.add_child(object,true)
				if count == 130:
					yield(get_tree().create_timer(0.25), "timeout")
					count = 0
	yield(get_tree().create_timer(1.5), "timeout")
	for id in map["flower"]:
		if not $NatureObjects.has_node(id):
			var loc = map["flower"][id]["l"]
			Tiles.remove_nature_invalid_tiles(loc, "flower")
			if validTiles.get_cellv(loc) != -1:
				if Util.chance(50):
					var object = Weed.instance()
					object.name = id
					object.location = loc
					object.position = dirt.map_to_world(loc) + Vector2(16, 32)
					$NatureObjects.add_child(object,true)
				else:
					var object = Flower.instance()
					object.name = id
					object.location = loc
					object.position = dirt.map_to_world(loc)
					$NatureObjects.add_child(object,true)
				if count == 130:
					yield(get_tree().create_timer(0.25), "timeout")
					count = 0
	print("SPAWNED CHUNK")
#			count += 1
#			if count == 130:
#				yield(get_tree().create_timer(0.25), "timeout")
#				count = 0



func set_nav():
	var player_loc = validTiles.world_to_map(Server.player_node.position)
	set_player_quadrant(player_loc)
	navTiles.clear()
	for x in range(60):
		for y in range(60):
			var loc = player_loc+Vector2(-30,-30)+Vector2(x,y)
			if validTiles.get_cellv(loc) != -1 and Tiles.isCenterBitmaskTile(loc, validTiles):
				navTiles.set_cellv(loc,0)
			elif wetSand.get_cellv(loc) != -1 and deep_ocean.get_cellv(loc) == -1:
				navTiles.set_cellv(loc,0)
	$Timer.start()

func _on_Timer_timeout():
	set_nav()

func update_tile_bitmask_regions():
	dirt.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	snow.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	waves.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	sand.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	plains.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	forest.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	wetSand.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	deep_ocean.update_bitmask_region()


func spawn_animals():
	for i in range(NUM_BUNNIES):
		spawnRandomBunny()
	for i in range(NUM_DUCKS):
		spawnRandomDuck()
	for i in range(NUM_BEARS):
		spawnRandomBear()
	for i in range(NUM_BOARS):
		spawnRandomBoar()
	for i in range(NUM_DEER):
		spawnRandomDeer()
	
func set_random_beach_forage():
	for id in Server.generated_map["beach"]:
		if Util.chance(4):
			var loc = Server.generated_map["beach"][id]
			if dirt.get_cellv(loc) == -1 and forest.get_cellv(loc) == -1 and snow.get_cellv(loc) == -1 and plains.get_cellv(loc) == -1:
				if Util.chance(50):
					var clam = Clam.instance()
					clam.location = loc
					clam.global_position = Tiles.valid_tiles.map_to_world(loc)
					$ForageItems.add_child(clam)
				else:
					var starfish = Starfish.instance()
					starfish.location = loc
					starfish.global_position = Tiles.valid_tiles.map_to_world(loc)
					$ForageItems.add_child(starfish)

	
func set_water_tiles():
	for x in range(1000): # fill ocean
		for y in range(1000):
			if dirt.get_cell(x, y) == -1 and plains.get_cell(x, y) == -1 and forest.get_cell(x, y) == -1 and snow.get_cell(x, y) == -1 and sand.get_cell(x,y) == -1:
				wetSand.set_cell(x, y, 0)
				waves.set_cell(x, y, 5)
				shallow_ocean.set_cell(x,y,0)
				top_ocean.set_cell(x,y,0)
				deep_ocean.set_cell(x,y,0)
				validTiles.set_cell(x, y, -1)
	for loc in waves.get_used_cells(): # remove outer layer to show wet sand
		if sand.get_cellv(loc+Vector2(1,0)) != -1 or sand.get_cellv(loc+Vector2(-1,0)) != -1 or sand.get_cellv(loc+Vector2(0,1)) != -1 or sand.get_cellv(loc+Vector2(0,-1)) != -1:
			waves.set_cellv(loc, -1)
			shallow_ocean.set_cellv(loc,-1)
			deep_ocean.set_cellv(loc,-1)
			top_ocean.set_cellv(loc,-1)
	for loc in wetSand.get_used_cells(): # add outer layer to show wet sand
		if wetSand.get_cellv(loc+Vector2(1,0)) != -1 or wetSand.get_cellv(loc+Vector2(-1,0)) != -1 or wetSand.get_cellv(loc+Vector2(0,1)) != -1 or wetSand.get_cellv(loc+Vector2(0,-1)) != -1:
			wetSand.set_cellv(loc+Vector2(1,0), 0)
			wetSand.set_cellv(loc+Vector2(-1,0), 0)
			wetSand.set_cellv(loc+Vector2(0,1), 0)
			wetSand.set_cellv(loc+Vector2(0,-1), 0)
	for loc in waves.get_used_cells(): # remove outer layer to show wet sand
		if wetSand.get_cellv(loc+Vector2(1,0)) != -1 or wetSand.get_cellv(loc+Vector2(-1,0)) != -1 or wetSand.get_cellv(loc+Vector2(0,1)) != -1 or wetSand.get_cellv(loc+Vector2(0,-1)) != -1:
			wetSand.set_cellv(loc+Vector2(1,0), 0)
			wetSand.set_cellv(loc+Vector2(-1,0), 0)
			wetSand.set_cellv(loc+Vector2(0,1), 0)
			wetSand.set_cellv(loc+Vector2(0,-1), 0)
	for loc in shallow_ocean.get_used_cells():
		for i in range(6): # shallow depth length
			if shallow_ocean.get_cellv(loc+Vector2(i,0)) == -1 or shallow_ocean.get_cellv(loc+Vector2(-i,0)) == -1 or shallow_ocean.get_cellv(loc+Vector2(0,i)) == -1 or shallow_ocean.get_cellv(loc+Vector2(0,-i)) == -1:
				deep_ocean.set_cellv(loc+Vector2(1,0), -1)
				deep_ocean.set_cellv(loc+Vector2(-1,0), -1)
				deep_ocean.set_cellv(loc+Vector2(0,1), -1)
				deep_ocean.set_cellv(loc+Vector2(0,-1), -1)
#	for x in range(300): # fill empty tiles
#		for y in range(300):
#			if dirt.get_cell(x, y) == -1 and plains.get_cell(x, y) == -1 and forest.get_cell(x, y) == -1 and snow.get_cell(x, y) == -1 and sand.get_cell(x,y) == -1:
#				Tiles._set_cell(sand, x, y, 0)
	
func fill_biome_gaps(map):
	for i in range(2):
		for loc in sand.get_used_cells():
			if Tiles.return_neighboring_cells(loc, sand) != 4:
				Tiles._set_cell(sand, loc.x+1, loc.y, 0)
				Tiles._set_cell(sand, loc.x-1, loc.y, 0)
				Tiles._set_cell(sand, loc.x, loc.y+1, 0)
				Tiles._set_cell(sand, loc.x, loc.y-1, 0)
		for loc in dirt.get_used_cells():
			if Tiles.return_neighboring_cells(loc, dirt) != 4:
				dirt.set_cellv(loc + Vector2(1, 0), 0)
				dirt.set_cellv(loc + Vector2(-1, 0), 0)
				dirt.set_cellv(loc + Vector2(0, 1), 0)
				dirt.set_cellv(loc + Vector2(0, -1), 0)
		for loc in snow.get_used_cells():
			if Tiles.return_neighboring_cells(loc, snow) != 4:
				snow.set_cellv(loc + Vector2(1, 0), 0)
				snow.set_cellv(loc + Vector2(-1, 0), 0)
				snow.set_cellv(loc + Vector2(0, 1), 0)
				snow.set_cellv(loc + Vector2(0, -1), 0)
		for loc in plains.get_used_cells():
			if Tiles.return_neighboring_cells(loc, dirt) != 4:
				plains.set_cellv(loc + Vector2(1, 0), 0)
				plains.set_cellv(loc + Vector2(-1, 0), 0)
				plains.set_cellv(loc + Vector2(0, 1), 0)
				plains.set_cellv(loc + Vector2(0, -1), 0)
		for loc in forest.get_used_cells():
			if Tiles.return_neighboring_cells(loc, forest) != 4:
				forest.set_cellv(loc + Vector2(1, 0), 0)
				forest.set_cellv(loc + Vector2(-1, 0), 0)
				forest.set_cellv(loc + Vector2(0, 1), 0)
				forest.set_cellv(loc + Vector2(0, -1), 0)
	yield(get_tree().create_timer(0.25), "timeout")
	

func check_and_remove_invalid_autotiles(map):
	for i in range(4):
		for cell in plains.get_used_cells(): 
			if not Tiles.isValidAutoTile(cell, plains):
				plains.set_cellv(cell, -1)
		for cell in forest.get_used_cells(): 
			if not Tiles.isValidAutoTile(cell, forest):
				forest.set_cellv(cell, -1)
		for cell in waves.get_used_cells():
			if not Tiles.isValidAutoTile(cell, waves):
				waves.set_cellv(cell, -1)
				deep_ocean.set_cellv(cell, -1)
				shallow_ocean.set_cellv(cell, -1)
				top_ocean.set_cellv(cell, -1)
		for cell in snow.get_used_cells():
			if not Tiles.isValidAutoTile(cell, snow):
				snow.set_cellv(cell, -1)
		for cell in dirt.get_used_cells():
			if not Tiles.isValidAutoTile(cell, dirt):
				dirt.set_cellv(cell, -1)
		for cell in sand.get_used_cells():
			if not Tiles.isValidAutoTile(cell, sand):
				sand.set_cellv(cell, -1)
		for cell in wetSand.get_used_cells():
			if not Tiles.isValidAutoTile(cell, wetSand):
				wetSand.set_cellv(cell, -1)
				Tiles._set_cell(sand, cell.x, cell.y, 0)
		yield(get_tree().create_timer(1.0), "timeout")

func build_valid_tiles():
	for x in range(800):
		for y in range(800):
			validTiles.set_cellv(Vector2(x+1, y+1), 0)

func ChangeTile(data):
	var loc = Util.string_to_vector2(data["l"])
	if data["isWatered"]:
		watered.set_cellv(loc, 0)
		hoed.set_cellv(loc, 0)
	elif data["isHoed"] and not data["isWatered"]:
		hoed.set_cellv(loc, 0)
	else: 
		hoed.set_cellv(loc, -1)
		watered.set_cellv(loc, -1)
		validTiles.set_cellv(loc, 0)
	hoed.update_bitmask_region()
	watered.update_bitmask_region()


#func UpdateWorldState(world_state):
##	if Server.day == null:
##		if get_node("Players").has_node(Server.player_id):
##			get_node("Players/" + Server.player_id).init_day_night_cycle(int(world_state["time_elapsed"]))
#	if world_state["t"] > last_world_state:
#		var new_day = bool(world_state["day"])
#		if has_node(active_player):
#			get_node(active_player + "/Camera2D/UserInterface/CurrentTime").update_time(int(world_state["time_elapsed"]))
#		if Server.day != new_day and Server.isLoaded:
#			Server.day = new_day
#			if new_day == false:
#				if has_node(active_player):
#					pass
#					#get_node(active_player).set_night()
#			else:
#				if has_node(active_player):
#					pass
#					#watered.clear()
#					#get_node(active_player).set_day()
#		last_world_state = world_state["t"]
#		world_state_buffer.append(world_state)


#func _physics_process(delta):
#	var render_time = OS.get_system_time_msecs() - interpolation_offset
#	if world_state_buffer.size() > 1:
#		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].t:
#			world_state_buffer.remove(0)
#		if world_state_buffer.size() > 2:
#			for decoration in world_state_buffer[2]["decorations"].keys():
#				match decoration:
#					"seed":
#						for item in world_state_buffer[2]["decorations"][decoration].keys():
#							var data = world_state_buffer[2]["decorations"][decoration][item]
#							if has_node(str(item)):
#								get_node(str(item)).days_until_harvest = data["d"]
#								get_node(str(item)).refresh_image()
#			var interpolation_factor = float(render_time - world_state_buffer[1]["t"]) / float(world_state_buffer[2]["t"] - world_state_buffer[1]["t"])
#			for player in world_state_buffer[2]["players"].keys():
#				if str(player) == "t":
#					continue
#				if str(player) == Server.player_id:
#					continue
#				if Players.has_node(str(player)):
#					var player_node = Players.get_node(str(player))
#					if world_state_buffer[1]["players"].has(player):
#						var new_position = lerp(world_state_buffer[1]["players"][player]["p"], world_state_buffer[2]["players"][player]["p"], interpolation_factor)
#						player_node.move(new_position, world_state_buffer[1]["players"][player]["d"])
#				else:
#					spawnNewPlayer(world_state_buffer[2]["players"][player])
#		elif render_time > world_state_buffer[1].t:
#			#var extrapolation_factor = float(render_time - world_state_buffer[0]["t"]) / float(world_state_buffer[1]["t"] - world_state_buffer[0]["t"]) - 1.00
#			for player in world_state_buffer[1]["players"].keys():
#				if str(player) == "t":
#					continue
#				if str(player) == Server.player_id:
#					continue
#				if Players.has_node(str(player)):
#					pass
#					#var position_delta = (Util.string_to_vector2(world_state_buffer[1]["players"][player]["p"]) - Util.string_to_vector2(world_state_buffer[0]["players"][player]["p"]))
#					#var new_position = Util.string_to_vector2(world_state_buffer[1]["players"][player]["p"]) + (position_delta * extrapolation_factor)
#					#$Players.get_node(str(player)).MovePlayer(new_position, world_state_buffer[1]["players"][player]["d"])


func returnValidSpawnLocation():
	rng.randomize()
	var tempLoc = Vector2(rng.randi_range(4000, 28000), rng.randi_range(4000, 28000))
	if validTiles.get_cellv(validTiles.world_to_map(tempLoc)) != -1:
		return tempLoc
	tempLoc = Vector2(rng.randi_range(4000, 28000), rng.randi_range(4000, 28000))
	if validTiles.get_cellv(validTiles.world_to_map(tempLoc)) != -1:
		return tempLoc
	return null


func spawnRandomBunny():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var bunny = Bunny.instance()
		bunny.global_position = loc
		$Animals.add_child(bunny)

func spawnRandomDuck():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var duck = Duck.instance()
		duck.global_position = loc
		$Animals.add_child(duck)

func spawnRandomBear():
	var loc = returnValidSpawnLocation()
	if loc != null:
		print("SPAWN BEAR")
		var bear = Bear.instance()
		$Animals.add_child(bear)
		bear.global_position = loc
		
func spawnRandomBoar():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var boar = Boar.instance()
		$Animals.add_child(boar)
		boar.global_position = loc

func spawnRandomDeer():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var deer = Deer.instance()
		$Animals.add_child(deer)
		deer.global_position = loc

func play_watering_can_effect(loc):
	var wateringCanEffect = WateringCanEffect.instance()
	wateringCanEffect.global_position = validTiles.map_to_world(loc) + Vector2(16,16)
	add_child(wateringCanEffect)
	
func play_hoed_dirt_effect(loc):
	var hoedDirtEffect = HoedDirtEffect.instance()
	hoedDirtEffect.global_position = validTiles.map_to_world(loc) + Vector2(16,20)
	add_child(hoedDirtEffect)

func play_dirt_trail_effect(velocity):
	var dirtTrailEffect = DirtTrailEffect.instance()
	if velocity.x < 0:
		dirtTrailEffect.flip_h  = true
	dirtTrailEffect.global_position = Server.player_node.global_position
	add_child(dirtTrailEffect)
	
func play_upgrade_building_effect(loc):
	var upgradeBuildingEffect = UpgradeBuildingEffect.instance()
	upgradeBuildingEffect.global_position = validTiles.map_to_world(loc) + Vector2(16,16)
	add_child(upgradeBuildingEffect)
	
func play_remove_building_effect(loc):
	var removeBuildingEffect = RemoveBuildingEffect.instance()
	removeBuildingEffect.global_position = validTiles.map_to_world(loc) + Vector2(16,16)
	add_child(removeBuildingEffect)
	



func _on_SpawnBearTimer_timeout():
	spawnRandomBear()
	spawnRandomDuck()
	spawnRandomBunny()
