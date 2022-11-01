extends YSort

var build_tiles = true

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
onready var LightningLine = preload("res://World/Objects/Misc/LightningLine.tscn")

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

var trees_thread := Thread.new()
var ores_thread := Thread.new()
var grass_thread := Thread.new()
var flower_thread := Thread.new()
var remove_objects_thread := Thread.new()
var remove_grass_thread := Thread.new()
var navigation_thread := Thread.new()


var object_name
var position_of_object
var object_variety
var day_num = 1
var season = "spring"
var valid_spawn_position
var random_rain_storm_position
var random_snow_storm_position

const NUM_DUCKS = 400
const NUM_BUNNIES = 400
const NUM_BEARS = 100
const NUM_BOARS = 0
const NUM_DEER = 0

const _character = preload("res://Global/Data/Characters.gd")

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 30
var mark_for_despawn = []
var tile_ids = {}

const BATCH_DRAW_COUNT = 2000
const BATCH_DRAW_DELAY = 0.25

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

func draw_mst(path):
	var current_lines = []
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				if not current_lines.has([Vector2(pp.x, pp.y), Vector2(cp.x, cp.y)]) and not current_lines.has([Vector2(cp.x, cp.y), Vector2(pp.x, pp.y)]):
					var lightning_line = LightningLine.instance()
					current_lines.append([Vector2(pp.x, pp.y), Vector2(cp.x, cp.y)])
					lightning_line.points = [Vector2(pp.x, pp.y), Vector2(cp.x, cp.y)]
					add_child(lightning_line)


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
	Tiles.wet_sand_tiles = $GeneratedTiles/WetSandBeachBorder
	print("BUILDING MAP")
	get_node("loadingScreen").set_phase("Building terrain")
	if build_tiles:
		var count = 0
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
			count += 1
			if count == BATCH_DRAW_COUNT:
				yield(get_tree().create_timer(BATCH_DRAW_DELAY), "timeout")
				count = 0
	#	hoed.update_bitmask_region()
	#	watered.update_bitmask_region()
		print("LOADED DIRT")
		yield(get_tree().create_timer(0.5), "timeout")
		for id in map["plains"]:
			var loc = map["plains"][id]
			plains.set_cellv(loc, 0)
			count += 1
			if count == BATCH_DRAW_COUNT:
				yield(get_tree().create_timer(BATCH_DRAW_DELAY), "timeout")
				count = 0
		print("LOADED PLAINS")
		yield(get_tree().create_timer(0.5), "timeout")
		for id in map["forest"]:
			var loc = map["forest"][id]
			forest.set_cellv(loc, 0)
			count += 1
			if count == BATCH_DRAW_COUNT:
				yield(get_tree().create_timer(BATCH_DRAW_DELAY), "timeout")
				count = 0
		print("LOADED DG")
		yield(get_tree().create_timer(0.5), "timeout")
		for id in map["snow"]:
			var loc = map["snow"][id]
			snow.set_cellv(loc, 0)
			count += 1
			if count == BATCH_DRAW_COUNT:
				yield(get_tree().create_timer(BATCH_DRAW_DELAY), "timeout")
				count = 0
		for id in map["desert"]:
			var loc = map["desert"][id]
			#desert.set_cellv(loc, 0)
			Tiles._set_cell(sand, loc.x, loc.y, 0)
			count += 1
			if count == BATCH_DRAW_COUNT:
				yield(get_tree().create_timer(BATCH_DRAW_DELAY), "timeout")
				count = 0
		for id in map["beach"]:
			var loc = map["beach"][id]
			Tiles._set_cell(sand, loc.x, loc.y, 0)
			count += 1
			if count == BATCH_DRAW_COUNT:
				yield(get_tree().create_timer(BATCH_DRAW_DELAY), "timeout")
				count = 0
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
	$SpawnNature.start()
	$SpawnBearTimer.start()
	Server.isLoaded = true
	Server.world = self
	spawn_animals()
	set_random_beach_forage()
	#set_nature_object_quadrants()
	#set_nav()

func remove_nature():
	for node in $NatureObjects.get_children():
		if is_instance_valid(node):
			var player_pos = Server.player_node.position
			if player_pos.distance_to(node.position) > Constants.DISTANCE_TO_SPAWN_OBJECT*32:
				$NatureObjects.remove_child(node)
				#node.queue_free()
				yield(get_tree().create_timer(0.01), "timeout")
	var value = remove_objects_thread.wait_to_finish()

func remove_grass():
	for node in $GrassObjects.get_children():
		if is_instance_valid(node):
			var player_pos = Server.player_node.position
			if player_pos.distance_to(node.position) > Constants.DISTANCE_TO_SPAWN_OBJECT*32:
				$GrassObjects.remove_child(node)
				yield(get_tree().create_timer(0.01), "timeout")
	var value = remove_grass_thread.wait_to_finish()

func spawn_trees():
	var player_loc = validTiles.world_to_map(Server.player_node.position)
	var map = Server.generated_map
	for id in map["tree"]:
		var loc = map["tree"][id]["l"] + Vector2(1,0)
		if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
			if not $NatureObjects.has_node(id):
				Tiles.remove_valid_tiles(loc+Vector2(-1,0), Vector2(2,2))
				var biome = map["tree"][id]["b"]
				if biome == "desert":
					var object = DesertTree.instance()
					var pos = dirt.map_to_world(loc)
					object.health = map["tree"][id]["h"]
					object.position = pos + Vector2(0, -8)
					object.name = id
					object.location = loc
					$NatureObjects.call_deferred("add_child",object,true)
					yield(get_tree().create_timer(0.01), "timeout")
				else:
					treeTypes.shuffle()
					var object = TreeObject.instance()
					var pos = dirt.map_to_world(loc)
					object.biome = biome
					object.health = map["tree"][id]["h"]
					object.variety = treeTypes.front()
					object.location = loc
					object.position = pos + Vector2(0, -8)
					object.name = id
					$NatureObjects.call_deferred("add_child",object,true)
					yield(get_tree().create_timer(0.01), "timeout")
	yield(get_tree().create_timer(0.1), "timeout")
	for id in map["log"]:
		var loc = map["log"][id]["l"]
		if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
			if not $NatureObjects.has_node(id):
				Tiles.remove_valid_tiles(loc)
				var variety = rng.randi_range(0, 11)
				var object = Log.instance()
				object.name = id
				object.variety = variety
				object.location = loc
				object.position = dirt.map_to_world(loc) + Vector2(16, 16)
				$NatureObjects.call_deferred("add_child",object,true)
				yield(get_tree().create_timer(0.01), "timeout")
	yield(get_tree().create_timer(0.1), "timeout")
	for id in map["stump"]:
		var loc = map["stump"][id]["l"] + Vector2(1,0)
		if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
			if not $NatureObjects.has_node(id):
				Tiles.remove_valid_tiles(loc+Vector2(-1,0), Vector2(2,2))
				treeTypes.shuffle()
				var object = Stump.instance()
				object.variety = treeTypes.front()
				object.location = loc
				object.health = map["stump"][id]["h"]
				object.name = id
				object.position = dirt.map_to_world(loc) + Vector2(4,0)
				$NatureObjects.call_deferred("add_child",object,true)
				yield(get_tree().create_timer(0.01), "timeout")
	var value = trees_thread.wait_to_finish()

func spawn_ores():
	var map = Server.generated_map
	for id in map["ore_large"]:
		var loc = map["ore_large"][id]["l"]
		var player_loc = validTiles.world_to_map(Server.player_node.position)
		if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
			if not $NatureObjects.has_node(id):
				Tiles.remove_valid_tiles(loc+Vector2(-1,0), Vector2(2,2))
				oreTypes.shuffle()
				var object = LargeOre.instance()
				object.health = map["ore_large"][id]["h"]
				object.name = id
				object.variety = oreTypes.front()
				object.location = loc
				object.position = dirt.map_to_world(loc) 
				$NatureObjects.call_deferred("add_child",object,true)
				yield(get_tree().create_timer(0.01), "timeout")
	yield(get_tree().create_timer(0.1), "timeout")
	for id in map["ore"]:
		var loc = map["ore"][id]["l"]
		var player_loc = validTiles.world_to_map(Server.player_node.position)
		if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
			if not $NatureObjects.has_node(id):
				Tiles.remove_valid_tiles(loc)
				oreTypes.shuffle()
				var object = SmallOre.instance()
				object.health = map["ore"][id]["h"]
				object.name = id
				object.variety = oreTypes.front()
				object.location = loc
				object.position = dirt.map_to_world(loc) + Vector2(16, 24)
				$NatureObjects.call_deferred("add_child",object,true)
				yield(get_tree().create_timer(0.01), "timeout")
	var value = ores_thread.wait_to_finish()

func spawn_grass():
	var map = Server.generated_map
	for id in map["tall_grass"]:
		var loc = map["tall_grass"][id]["l"]
		var player_loc = validTiles.world_to_map(Server.player_node.position)
		if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
			if not $GrassObjects.has_node(id):
				Tiles.add_navigation_tiles(loc)
				var object = TallGrass.instance()
				object.loc = loc
				object.biome = map["tall_grass"][id]["b"]
				object.name = id
				object.position = dirt.map_to_world(loc) + Vector2(8, 32)
				$GrassObjects.call_deferred("add_child",object,true)
	var value = grass_thread.wait_to_finish()

func spawn_flowers():
	var map = Server.generated_map
	for id in map["flower"]:
		var loc = map["flower"][id]["l"]
		var player_loc = validTiles.world_to_map(Server.player_node.position)
		if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
			if not $GrassObjects.has_node(id):
				Tiles.add_navigation_tiles(loc)
				if Util.chance(50):
					var object = Weed.instance()
					object.name = id
					object.location = loc
					object.position = dirt.map_to_world(loc) + Vector2(16, 32)
					$GrassObjects.call_deferred("add_child",object,true)
				else:
					var object = Flower.instance()
					object.name = id
					object.location = loc
					object.position = dirt.map_to_world(loc)
					$GrassObjects.call_deferred("add_child",object,true)
	var value = flower_thread.wait_to_finish()


func _whoAmI(_value):
	call_deferred("remove_nature")
	
func _whoAmI5(_value):
	call_deferred("remove_grass")
	
func _whoAmI2(_value):
	call_deferred("spawn_trees")
	
func _whoAmI3(_value):
	call_deferred("spawn_ores")
	
func _whoAmI4(_value):
	call_deferred("spawn_grass")

func _whoAmI6(_value):
	call_deferred("spawn_flowers")
	
func _whoAmI7(_value):
	call_deferred("set_nav")

func spawn_nature():
	if not remove_objects_thread.is_active():
		remove_objects_thread.start(self, "_whoAmI", null)
	if not remove_grass_thread.is_active():
		remove_grass_thread.start(self, "_whoAmI5", null)
	if not trees_thread.is_active():
		trees_thread.start(self, "_whoAmI2", null)
	if not ores_thread.is_active():
		ores_thread.start(self, "_whoAmI3", null)
	if not grass_thread.is_active():
		grass_thread.start(self, "_whoAmI4", null)
	if not flower_thread.is_active():
		flower_thread.start(self, "_whoAmI6", null)
	if not navigation_thread.is_active():
		navigation_thread.start(self, "_whoAmI7", null)


func set_nav():
	var player_loc = validTiles.world_to_map(Server.player_node.position)
	navTiles.clear()
	#var count = 0
	for x in range(60):
		for y in range(60):
			var loc = player_loc+Vector2(-30,-30)+Vector2(x,y)
			if Tiles.isValidNavigationTile(loc):
				navTiles.set_cellv(loc,0)
			#count += 1
	#yield(get_tree(), "idle_frame")
	yield(get_tree().create_timer(1.0), "timeout")
	var value = navigation_thread.wait_to_finish()
#			if validTiles.get_cellv(loc) != -1 and Tiles.isCenterBitmaskTile(loc, validTiles):
#				navTiles.set_cellv(loc,0)
#			elif wetSand.get_cellv(loc) != -1 and deep_ocean.get_cellv(loc) == -1:
#				navTiles.set_cellv(loc,0)
	#$Timer.start()

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
	yield(get_tree().create_timer(0.5), "timeout")
	shallow_ocean.update_bitmask_region()


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
		if Util.chance(3):
			var loc = Server.generated_map["beach"][id]
			if dirt.get_cellv(loc) == -1 and forest.get_cellv(loc) == -1 and snow.get_cellv(loc) == -1 and plains.get_cellv(loc) == -1:
				if Util.chance(50):
					Tiles.remove_valid_tiles(loc)
					var clam = Clam.instance()
					clam.location = loc
					clam.global_position = Tiles.valid_tiles.map_to_world(loc)
					$ForageObjects.add_child(clam)
				else:
					Tiles.add_navigation_tiles(loc)
					var starfish = Starfish.instance()
					starfish.location = loc
					starfish.global_position = Tiles.valid_tiles.map_to_world(loc)
					$ForageObjects.add_child(starfish)

	
func set_water_tiles():
	var count = 0
	for x in range(1000): # fill ocean
		for y in range(1000):
			if dirt.get_cell(x, y) == -1 and plains.get_cell(x, y) == -1 and forest.get_cell(x, y) == -1 and snow.get_cell(x, y) == -1 and sand.get_cell(x,y) == -1:
				wetSand.set_cell(x, y, 0)
				waves.set_cell(x, y, 5)
				shallow_ocean.set_cell(x,y,0)
				top_ocean.set_cell(x,y,0)
				deep_ocean.set_cell(x,y,0)
				validTiles.set_cell(x, y, -1)
#				count += 1
#				if count == BATCH_DRAW_COUNT*2:
#					yield(get_tree().create_timer(BATCH_DRAW_DELAY), "timeout")
#					count = 0
	for loc in waves.get_used_cells(): # remove outer layer to show wet sand
		if sand.get_cellv(loc+Vector2(1,0)) != -1 or sand.get_cellv(loc+Vector2(-1,0)) != -1 or sand.get_cellv(loc+Vector2(0,1)) != -1 or sand.get_cellv(loc+Vector2(0,-1)) != -1:
			waves.set_cellv(loc, -1)
			shallow_ocean.set_cellv(loc,-1)
			deep_ocean.set_cellv(loc,-1)
			top_ocean.set_cellv(loc,-1)
#			count += 1
#			if count == BATCH_DRAW_COUNT*2:
#				yield(get_tree().create_timer(BATCH_DRAW_DELAY), "timeout")
#				count = 0
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
	var tempLoc = Vector2(rng.randi_range(8000, 24000), rng.randi_range(8000, 24000))
	if validTiles.get_cellv(validTiles.world_to_map(tempLoc)) != -1:
		return tempLoc
	tempLoc = Vector2(rng.randi_range(8000, 24000), rng.randi_range(8000, 24000))
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
	pass
#	spawnRandomBear()
#	spawnRandomDuck()
#	spawnRandomBunny()

func _on_SpawnNature_timeout():
	spawn_nature()
