extends Node

onready var Bat = load("res://World/Enemies/Slime/Bat.tscn")
onready var CaveAmbientLight = load("res://World/Caves/CaveAmbientLight.tscn")
onready var LightningLine = load("res://World/Objects/Misc/LightningLine.tscn")
onready var Slime = load("res://World/Enemies/Slime/Slime.tscn")
onready var Spider = load("res://World/Enemies/Spider.tscn")
onready var FireMageSkeleton = load("res://World/Enemies/Skeleton.tscn")
onready var TileObjectHurtBox = load("res://World/Objects/Tiles/TileObjectHurtBox.tscn")
onready var CaveLadder = load("res://World/Caves/Objects/CaveLadder.tscn")
onready var LargeOre = load("res://World/Objects/Nature/Ores/LargeOre.tscn")
onready var SmallOre = load("res://World/Objects/Nature/Ores/SmallOre.tscn")
onready var TallGrass = load("res://World/Objects/Nature/Grasses/TallGrass.tscn")
onready var CaveGrass = load("res://World/Caves/Objects/CaveGrass.tscn")
onready var CaveLight = load("res://World/Caves/Objects/CaveLight.tscn")
onready var Player = load("res://World/Player/Player/Player.tscn")
onready var _character = load("res://Global/Data/Characters.gd")
onready var ForageItem = load("res://World/Objects/Nature/Forage/ForageItem.tscn")
var oreTypes = ["stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "bronze ore", "iron ore", "bronze ore", "iron ore", "gold ore"]
const randomAdjacentTiles = [Vector2(0, 1), Vector2(1, 1), Vector2(-1, 1), Vector2(0, -1), Vector2(-1, -1), Vector2(1, -1), Vector2(1, 0), Vector2(-1, 0)]
const mushroomTypes = ["common mushroom", "healing mushroom", "purple mushroom", "chanterelle"]
var _uuid = load("res://helpers/UUID.gd")
onready var uuid = _uuid.new()
var rng := RandomNumberGenerator.new()
const NUM_MUSHROOMS = 100
const NUM_SMALL_ORE = 20
const NUM_LARGE_ORE = 6
const MAX_TALL_GRASS_SIZE = 60
var count = 0
var nav_node

var valid_tiles
var NatureObjects
var GrassObjects
var ForageObjects 

func spawn_bat():
	var locs = Server.world.get_node("Tiles/BatSpawnTiles").get_used_cells()
	locs.shuffle()
	var bat = Bat.instance()
	Server.world.get_node("Enemies").add_child(bat)
	bat.position = locs[0]*32


func update_navigation():
	for x in range(Server.world.map_size):
		for y in range(Server.world.map_size):
			if Tiles.valid_tiles.get_cellv(Vector2(x,y)) != -1:
				Server.world.get_node("Navigation2D/NavTiles").set_cellv(Vector2(x,y),0)

func spawn_player():
	var spawn_loc
#	if PlayerData.spawn_at_respawn_location:
#		spawn_loc = Util.string_to_vector2(PlayerData.player_data["respawn_location"])
#	elif PlayerData.spawn_at_cave_entrance:
#		spawn_loc = Server.world.get_node("Tiles/UpLadder").get_used_cells()[0]
#	elif PlayerData.spawn_at_cave_exit:
#		spawn_loc = Server.world.get_node("Tiles/DownLadder").get_used_cells()[0]
	spawn_loc = Server.world.get_node("Tiles/UpLadder").get_used_cells()[0]
	var player = Player.instance()
	player.character = _character.new()
	player.character.LoadPlayerCharacter("human_male")
	Server.world.get_node("Players").add_child(player)
	player.position =  (spawn_loc*32)+Vector2(16,32)
	Server.player_node = player
	PlayerData.spawn_at_respawn_location = false
	PlayerData.spawn_at_cave_entrance = false
	PlayerData.spawn_at_cave_exit = false

func build():
	valid_tiles = Server.world.get_node("Tiles/ValidTiles")
	NatureObjects = Server.world.get_node("NatureObjects")
	GrassObjects = Server.world.get_node("GrassObjects")
	ForageObjects = Server.world.get_node("ForageObjects")
	Tiles.cave_wall_tiles = Server.world.get_node("Tiles/Walls")
	Tiles.valid_tiles = Server.world.get_node("Tiles/ValidTiles")
	Tiles.ocean_tiles = Server.world.get_node("Tiles/Water")
	Tiles.object_tiles = Server.world.get_node("PlacableTiles/ObjectTiles")
	Tiles.fence_tiles = Server.world.get_node("PlacableTiles/FenceTiles")
	Server.world.nav_node = Server.world.get_node("Navigation2D")
	rng.randomize()
	spawn_player()
	set_valid_tiles()
	set_light_nodes()
	set_cave_ladders()
	var cave = MapData.caves[Server.world.name]
	if cave["is_built"]:
		load_cave(cave)
	else:
		build_cave(cave)
	Server.world.get_node("Tiles/Chests").clear()
	spawn_enemies_randomly()
	add_ambient_light()
	
func add_ambient_light():
	var caveLight = CaveAmbientLight.instance()
	Server.world.add_child(caveLight)

func load_cave(map):
	#var map = MapData.return_cave_data(Server.world.name)
	for id in map["ore_large"]:
		var loc = Util.string_to_vector2(map["ore_large"][id]["l"])
		Tiles.remove_valid_tiles(loc+Vector2(-1,0), Vector2(2,2))
		var object = LargeOre.instance()
		object.health = map["ore_large"][id]["h"]
		object.name = id
		object.variety = map["ore_large"][id]["v"]
		object.location = loc
		object.position = Tiles.valid_tiles.map_to_world(loc) 
		NatureObjects.call_deferred("add_child",object,true)
	for id in map["ore"]:
		var loc = Util.string_to_vector2(map["ore"][id]["l"])
		Tiles.remove_valid_tiles(loc)
		oreTypes.shuffle()
		var object = SmallOre.instance()
		object.health = map["ore"][id]["h"]
		object.name = id
		object.variety = map["ore"][id]["v"]
		object.location = loc
		object.position = Tiles.valid_tiles.map_to_world(loc) + Vector2(16, 24)
		NatureObjects.call_deferred("add_child",object,true)
	for id in map["tall_grass"]:
		var loc = Util.string_to_vector2(map["tall_grass"][id]["l"])
		Tiles.add_navigation_tiles(loc)
		var caveGrass = CaveGrass.instance()
		caveGrass.name = str(id)
		caveGrass.variety = map["tall_grass"][id]["v"]
		caveGrass.loc = loc
		GrassObjects.call_deferred("add_child", caveGrass)
		caveGrass.position = loc*32 + Vector2(16,32)
	for id in map["mushroom"]:
		var loc = Util.string_to_vector2(map["mushroom"][id]["l"])
		Tiles.add_navigation_tiles(loc)
		var forageItem = ForageItem.instance()
		forageItem.name = str(id)
		forageItem.type = "mushroom"
		forageItem.variety = map["mushroom"][id]["v"]
		forageItem.location = loc
		ForageObjects.call_deferred("add_child", forageItem)
		forageItem.position = loc*32 + Vector2(16,32)
	for id in map["placables"]:
		var item_name = map["placables"][id]["n"]
		var location = Util.string_to_vector2(map["placables"][id]["l"])
		var direction = map["placables"][id]["d"]
		PlaceObject.place_object_in_world(id,item_name,direction,location)


func build_cave(map):
	set_initial_chest(map)
	if Server.world.name != "Cave 1-Fishing":
		generate_ore(map)
		generate_tall_grass(map)
		generate_mushroom_forage(map)
	map["is_built"] = true

func set_valid_tiles():
	for x in range(Server.world.map_size):
		for y in range(Server.world.map_size):
			if Tiles.cave_wall_tiles.get_cell(x,y) == -1:
				valid_tiles.set_cell(x,y,0)
	for loc in Server.world.get_node("Tiles/Rail").get_used_cells():
		if valid_tiles.get_cellv(loc) != -1:
			valid_tiles.set_cellv(loc, 1)
	for loc in Server.world.get_node("Tiles/Hole").get_used_cells():
		valid_tiles.set_cellv(loc, -1)
		valid_tiles.set_cellv(loc+Vector2(0,-1), -1)
		valid_tiles.set_cellv(loc+Vector2(0,-2), -1)
	for loc in Server.world.get_node("Tiles/Fence").get_used_cells():
		valid_tiles.set_cellv(loc, -1)
	for loc in Server.world.get_node("Tiles/Decoration").get_used_cells():
		var type = Server.world.get_node("Tiles/Decoration").get_cellv(loc)
		if type == 7:
			valid_tiles.set_cellv(loc, -1)
			valid_tiles.set_cellv(loc+Vector2(1,0), -1)
			valid_tiles.set_cellv(loc+Vector2(2,0), -1)
			valid_tiles.set_cellv(loc+Vector2(3,0), -1)
			valid_tiles.set_cellv(loc+Vector2(5,0), -1)
			valid_tiles.set_cellv(loc+Vector2(6,0), -1)
			valid_tiles.set_cellv(loc+Vector2(7,0), -1)
			valid_tiles.set_cellv(loc+Vector2(8,0), -1)
		elif type == 6:
			valid_tiles.set_cellv(loc, 1)
			valid_tiles.set_cellv(loc+Vector2(1,0), 1)
			valid_tiles.set_cellv(loc+Vector2(2,0), 1)
			valid_tiles.set_cellv(loc+Vector2(3,0), 1)
			valid_tiles.set_cellv(loc+Vector2(5,0), 1)
			valid_tiles.set_cellv(loc+Vector2(6,0), 1)
			valid_tiles.set_cellv(loc+Vector2(7,0), 1)
		elif type == 8:
			valid_tiles.set_cellv(loc, 1)
			valid_tiles.set_cellv(loc+Vector2(1,0), 1)
			valid_tiles.set_cellv(loc+Vector2(2,0), 1)
			valid_tiles.set_cellv(loc+Vector2(3,0), 1)
			valid_tiles.set_cellv(loc+Vector2(0,1), 1)
			valid_tiles.set_cellv(loc+Vector2(1,1), 1)
			valid_tiles.set_cellv(loc+Vector2(2,1), 1)
			valid_tiles.set_cellv(loc+Vector2(3,1), 1)
		elif type == 0 or type == 1 or type == 2:
			valid_tiles.set_cellv(loc, -1)
		elif type == 3 or type == 4 or type == 5 or type == 12 or type == 13 or type == 14 or type == 15 or type == 16 or type == 17 or type == 18 or type == 21:
			valid_tiles.set_cellv(loc, -1)
			valid_tiles.set_cellv(loc+Vector2(1,0), -1)
		elif type == 19 or type == 20:
			valid_tiles.set_cellv(loc, -1)
			valid_tiles.set_cellv(loc+Vector2(0,-1), -1)
	# ladders
	if Server.world.get_node("Tiles/DownLadder").get_used_cells().size() != 0:
		var ladder_loc = Server.world.get_node("Tiles/DownLadder").get_used_cells()[0]
		valid_tiles.set_cellv(ladder_loc, -1)
		valid_tiles.set_cellv(ladder_loc+Vector2(1,0), -1)
	var up_ladder_loc = Server.world.get_node("Tiles/UpLadder").get_used_cells()[0]
	valid_tiles.set_cellv(up_ladder_loc, -1)
	valid_tiles.set_cellv(up_ladder_loc+Vector2(0,1), -1)
	

func spawn_enemies_randomly():
	var locs = valid_tiles.get_used_cells()
	locs.shuffle()
	for i in range(Server.world.NUM_SLIMES):
		var slime = Slime.instance()
		Server.world.get_node("Enemies").add_child(slime)
		slime.position = locs[i]*32 + Vector2(16,16)
	locs.shuffle()
	for i in range(Server.world.NUM_SPIDERS):
		var spider = Spider.instance()
		Server.world.get_node("Enemies").add_child(spider)
		spider.position = locs[i]*32 + Vector2(16,16)
	locs.shuffle()
	for i in range(Server.world.NUM_SKELETONS):
		var skele = FireMageSkeleton.instance()
		Server.world.get_node("Enemies").add_child(skele)
		skele.position = locs[i]*32 + Vector2(16,16)
	
	
func set_initial_chest(map):
	var direction = return_chest_direction(Server.world.get_node("Tiles/Chests").get_used_cells()[0])
	var location = Server.world.get_node("Tiles/Chests").get_used_cells()[0]
	var type
	if Util.chance(50):
		type = "stone chest"
	else:
		type = "wood chest"
	MapData.add_placable(Server.world.name, {"n":type,"d":direction,"l":str(location)})
	PlaceObject.place_object_in_world(Server.world.name, type, direction, location)

func return_chest_direction(loc):
	var type = Server.world.get_node("Tiles/Chests").get_cellv(loc)
	if type == 0:
		return "down"
	elif type == 2:
		return "left"
	elif type == 1:
		return "right"

func set_cave_ladders():
	if Server.world.get_node("Tiles/DownLadder").get_used_cells().size() != 0:
		var caveLadder = CaveLadder.instance()
		caveLadder.is_down_ladder = true
		Server.world.add_child(caveLadder)
		caveLadder.position = (Server.world.get_node("Tiles/DownLadder").get_used_cells()[0] * 32) + Vector2(32,16)
	if Server.world.get_node("Tiles/UpLadder").get_used_cells().size() != 0:
		var caveLadder = CaveLadder.instance()
		caveLadder.is_down_ladder = false
		Server.world.add_child(caveLadder)
		caveLadder.position = (Server.world.get_node("Tiles/UpLadder").get_used_cells()[0] * 32) + Vector2(16,0)

func generate_mushroom_forage(map):
	for i in range(NUM_MUSHROOMS):
		var locs = valid_tiles.get_used_cells()
		locs.shuffle()
		var loc = locs[0]
		if Tiles.validate_tiles(loc, Vector2(1,1)):
			var id = uuid.v4()
			mushroomTypes.shuffle()
			Tiles.add_navigation_tiles(loc)
			var forageItem = ForageItem.instance()
			forageItem.type = "mushroom"
			forageItem.variety = mushroomTypes.front()
			forageItem.name = str(id)
			forageItem.location = loc
			forageItem.global_position = Tiles.valid_tiles.map_to_world(loc)
			ForageObjects.add_child(forageItem)
			map["forage"][id] = {"l": str(loc), "v": mushroomTypes.front()}
	
func generate_tall_grass(map):
	for i in range(4):
		var locs = valid_tiles.get_used_cells()
		locs.shuffle()
		var start_loc = locs[0]
		generate_grass_bunch(start_loc, i+1, map)
		
func generate_grass_bunch(loc, variety, map):
	rng.randomize()
	var randomNum = rng.randi_range(20, MAX_TALL_GRASS_SIZE)
	for _i in range(randomNum):
		randomAdjacentTiles.shuffle()
		loc += randomAdjacentTiles[0]
		if Tiles.valid_tiles.get_cellv(loc) == 0:
			var id = uuid.v4()
			Tiles.add_navigation_tiles(loc)
			var caveGrass = CaveGrass.instance()
			caveGrass.name = str(id)
			caveGrass.variety = variety
			caveGrass.loc = loc
			GrassObjects.call_deferred("add_child", caveGrass)
			caveGrass.position = loc*32 + Vector2(16,32)
			map["tall_grass"][id] = {"l": str(loc), "v": variety}
		else:
			loc -= randomAdjacentTiles[0]
	
	
func generate_ore(map):
	for i in range(NUM_SMALL_ORE):
		var locs = valid_tiles.get_used_cells()
		locs.shuffle()
		var loc = locs[0]
		if Tiles.validate_tiles(loc, Vector2(1,1)):
			var id = uuid.v4()
			Tiles.remove_valid_tiles(loc)
			oreTypes.shuffle()
			var object = SmallOre.instance()
			object.name = str(id)
			object.health = Stats.SMALL_ORE_HEALTH
			object.variety = oreTypes.front()
			object.location = loc
			object.position = loc*32 + Vector2(16, 24)
			NatureObjects.call_deferred("add_child",object,true)
			map["ore"][id] = {"l": str(loc), "v": oreTypes.front(), "h": Stats.SMALL_ORE_HEALTH}
	while count < NUM_LARGE_ORE:
		var locs = valid_tiles.get_used_cells()
		locs.shuffle()
		var loc = locs[0]
		if Tiles.validate_tiles(loc+Vector2(-1,0), Vector2(2,2)):
			var id = uuid.v4()
			count += 1
			Tiles.remove_valid_tiles(loc+Vector2(-1,0), Vector2(2,2))
			oreTypes.shuffle()
			var object = LargeOre.instance()
			object.name = str(id)
			object.health = Stats.LARGE_ORE_HEALTH
			object.variety = oreTypes.front()
			object.location = loc
			object.position = loc*32
			NatureObjects.call_deferred("add_child",object,true)
			map["ore_large"][id] = {"l": str(loc), "v": oreTypes.front(), "h": Stats.LARGE_ORE_HEALTH}

func set_light_nodes():
	for loc in Server.world.get_node("Tiles/Lights").get_used_cells():
		var caveLight = CaveLight.instance()
		if Server.world.get_node("Tiles/Lights").get_cellv(loc) == 0: 
			caveLight.type = "blue"
		elif Server.world.get_node("Tiles/Lights").get_cellv(loc) == 1: 
			caveLight.type = "red"
		elif Server.world.get_node("Tiles/Lights").get_cellv(loc) == 2: 
			caveLight.type = "yellow"
		Server.world.get_node("LightObjects").add_child(caveLight)
		caveLight.position = loc*32 + Vector2(16,16)

