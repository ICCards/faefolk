extends YSort

var build_tiles = false

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

onready var Player = preload("res://World/Player/Player/Player.tscn")
onready var Player_pet = preload("res://World/Player/Pet/PlayerPet.tscn")
onready var Bear = preload("res://World/Animals/Bear.tscn")
onready var IC_Ghost = preload("res://World/Enemies/ICGhost.tscn")
onready var Bunny = preload("res://World/Animals/Bunny.tscn")
onready var Duck = preload("res://World/Animals/Duck.tscn")
onready var Boar = preload("res://World/Animals/Boar.tscn")
onready var Deer = preload("res://World/Animals/Deer.tscn")
onready var Wolf = preload("res://World/Animals/Wolf.tscn")
onready var Clam = preload("res://World/Objects/Nature/Forage/Clam.tscn")
onready var Starfish = preload("res://World/Objects/Nature/Forage/Starfish.tscn")
onready var WateringCanEffect = preload("res://World/Objects/Nature/Effects/WateringCan.tscn")
onready var HoedDirtEffect = preload("res://World/Objects/Nature/Effects/HoedDirt.tscn") 
onready var DirtTrailEffect = preload("res://World/Objects/Nature/Effects/DustTrailEffect.tscn")
onready var UpgradeBuildingEffect = preload("res://World/Objects/Nature/Effects/UpgradeBuilding.tscn")
onready var RemoveBuildingEffect = preload("res://World/Objects/Nature/Effects/RemoveBuilding.tscn")
onready var LightningLine = preload("res://World/Objects/Misc/LightningLine.tscn")
onready var CaveLadder = preload("res://World/Caves/Objects/CaveLadder.tscn")

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

const NUM_DUCKS = 250
const NUM_BUNNIES = 250
const NUM_BEARS = 30
const NUM_BOARS = 30
const NUM_DEER = 100
const NUM_WOLVES = 30

const _character = preload("res://Global/Data/Characters.gd")

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 30
var mark_for_despawn = []
var tile_ids = {}

const BATCH_DRAW_COUNT = 2000
const BATCH_DRAW_DELAY = 0.25


var is_changing_scene: bool = false


func _ready():
	buildMap(MapData.world)
	
func advance_down_cave_level():
	if not is_changing_scene:
		is_changing_scene = true
		get_node("BuildWorld/BuildNature").is_destroyed = true
		yield(get_tree(), "idle_frame")
		BuildCaveLevel.is_player_going_down = true
		Server.player_node.destroy()
		for enemy in $Enemies.get_children():
			enemy.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 1/Cave 1.tscn")

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
	$SpawnBearTimer.start()
	Server.isLoaded = true
	Server.world = self
	spawn_animals()
	create_cave_entrance(map["cave_entrance_location"])
	#set_random_beach_forage()

func create_cave_entrance(_loc):
	var loc = Util.string_to_vector2(_loc)
	$GeneratedTiles/DownLadder.set_cellv(loc, 1)
	var caveLadder = CaveLadder.instance()
	caveLadder.is_down_ladder = true
	caveLadder.position = loc*32 + Vector2(32,16)
	add_child(caveLadder)

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
	var map = MapData.world
	for id in map["tree"]:
		var loc = Util.string_to_vector2(map["tree"][id]["l"]) + Vector2(1,0)
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
		var loc = Util.string_to_vector2(map["log"][id]["l"])
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
		var loc = Util.string_to_vector2(map["stump"][id]["l"]) + Vector2(1,0)
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
	var map = MapData.world
	for id in map["ore_large"]:
		var loc = Util.string_to_vector2(map["ore_large"][id]["l"])
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
		var loc = Util.string_to_vector2(map["ore"][id]["l"])
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

#func spawn_grass():
#	var map = MapData.world
#	for id in map["tall_grass"]:
#		var loc = Util.string_to_vector2(map["tall_grass"][id]["l"])
#		var player_loc = validTiles.world_to_map(Server.player_node.position)
#		if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
#			if not $GrassObjects.has_node(id):
#				Tiles.add_navigation_tiles(loc)
#				var object = TallGrass.instance()
#				object.loc = loc
#				object.biome = map["tall_grass"][id]["b"]
#				object.name = id
#				object.position = dirt.map_to_world(loc) + Vector2(8, 32)
#				$GrassObjects.call_deferred("add_child",object,true)
#				yield(get_tree().create_timer(0.01), "timeout")
#	var value = grass_thread.wait_to_finish()

func spawn_flowers():
	var map = MapData.world
	for id in map["flower"]:
		var loc = Util.string_to_vector2(map["flower"][id]["l"])
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
				yield(get_tree().create_timer(0.01), "timeout")
	var value = flower_thread.wait_to_finish()

func set_nav():
	var player_loc = validTiles.world_to_map(Server.player_node.position)
	navTiles.clear()
	for y in range(40):
		for x in range(60):
			var loc = player_loc+Vector2(-30,-20)+Vector2(x,y)
			if Tiles.isValidNavigationTile(loc):
				#if navTiles.get_cellv(loc) != 0:
				navTiles.set_cellv(loc,0)
#			else:
#				#if navTiles.get_cellv(loc) != -1:
#				navTiles.set_cellv(loc,-1)
	yield(get_tree().create_timer(0.25), "timeout")
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
	for i in range(NUM_WOLVES):
		spawnRandomWolf()
	
#func set_random_beach_forage():
#	for id in Server.generated_map["beach"]:
#		if Util.chance(3):
#			var loc = Server.generated_map["beach"][id]
#			if dirt.get_cellv(loc) == -1 and forest.get_cellv(loc) == -1 and snow.get_cellv(loc) == -1 and plains.get_cellv(loc) == -1:
#				if Util.chance(50):
#					Tiles.remove_valid_tiles(loc)
#					var clam = Clam.instance()
#					clam.location = loc
#					clam.global_position = Tiles.valid_tiles.map_to_world(loc)
#					$ForageObjects.add_child(clam)
#				else:
#					Tiles.add_navigation_tiles(loc)
#					var starfish = Starfish.instance()
#					starfish.location = loc
#					starfish.global_position = Tiles.valid_tiles.map_to_world(loc)
#					$ForageObjects.add_child(starfish)

	
func set_water_tiles():
	#var count = 0
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


func returnValidSpawnLocation():
	rng.randomize()
	var tempLoc = Vector2(rng.randi_range(8000, 24000), rng.randi_range(8000, 24000))
	if validTiles.get_cellv(validTiles.world_to_map(tempLoc)) != -1:
		return tempLoc
	tempLoc = Vector2(rng.randi_range(8000, 24000), rng.randi_range(8000, 24000))
	if validTiles.get_cellv(validTiles.world_to_map(tempLoc)) != -1:
		return tempLoc
	return null


func spawnRandomWolf():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var wolf = Wolf.instance()
		wolf.global_position = loc
		$Enemies.add_child(wolf)

func spawnRandomBunny():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var bunny = Bunny.instance()
		bunny.global_position = loc
		$Enemies.add_child(bunny)

func spawnRandomDuck():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var duck = Duck.instance()
		duck.global_position = loc
		$Enemies.add_child(duck)

func spawnRandomBear():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var bear = Bear.instance()
		$Enemies.add_child(bear)
		bear.global_position = loc
		
func spawnRandomBoar():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var boar = Boar.instance()
		$Enemies.add_child(boar)
		boar.global_position = loc

func spawnRandomDeer():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var deer = Deer.instance()
		$Enemies.add_child(deer)
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

#func _on_SpawnNature_timeout():
#	spawn_nature()
	
	
	
	
func update_bitmasks(chunk_name):
	var row = chunk_name.substr(0)
	var column = chunk_name.substr(1)
	print(row)
	print(column)
	
#func update_bitmasks():
#	var player_loc = Server.player_node.position / 32
#	forest.update_bitmask_region(player_loc-Vector2(50,50), player_loc+Vector2(50,50))
#	yield(get_tree(), "idle_frame")
#	plains.update_bitmask_region(player_loc-Vector2(50,50), player_loc+Vector2(50,50))
#	yield(get_tree(), "idle_frame")
#	snow.update_bitmask_region(player_loc-Vector2(50,50), player_loc+Vector2(50,50))
#	yield(get_tree(), "idle_frame")
#	forest.update_bitmask_region(player_loc-Vector2(50,50), player_loc+Vector2(50,50))
#	yield(get_tree(), "idle_frame")
#	dirt.update_bitmask_region(player_loc-Vector2(50,50), player_loc+Vector2(50,50))
#	dirt.update_bitmask_region()
#	yield(get_tree().create_timer(0.5), "timeout")
#	snow.update_bitmask_region()
#	yield(get_tree().create_timer(0.5), "timeout")
#	waves.update_bitmask_region()
#	yield(get_tree().create_timer(0.5), "timeout")
#	sand.update_bitmask_region()
#	yield(get_tree().create_timer(0.5), "timeout")
#	plains.update_bitmask_region()
#	yield(get_tree().create_timer(0.5), "timeout")
#	forest.update_bitmask_region()
#	yield(get_tree().create_timer(0.5), "timeout")
#	wetSand.update_bitmask_region()
#	yield(get_tree().create_timer(0.5), "timeout")
#	deep_ocean.update_bitmask_region()
#	yield(get_tree().create_timer(0.5), "timeout")
#	shallow_ocean.update_bitmask_region()
