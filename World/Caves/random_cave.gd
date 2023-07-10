extends Node2D

@onready var Slime = load("res://World/Enemies/Slime/Slime.tscn")
@onready var Spider = load("res://World/Enemies/Spider.tscn")
@onready var Skeleton = load("res://World/Enemies/Skeleton.tscn")
@onready var Bat = load("res://World/Enemies/Slime/Bat.tscn")

@onready var Player = load("res://World/Player/Player/Player.tscn")
@onready var CaveLight = load("res://World/Caves/Objects/CaveLight.tscn")

@onready var wall_tiles: TileMap = $TerrainTiles/Walls
@onready var valid_tiles: TileMap = $TerrainTiles/ValidTiles
@onready var nav_tiles: TileMap = $TerrainTiles/NavigationTiles

var level = 1
var tier = "wind"

var map_size: int

var game_state: GameState

var is_changing_scene: bool = false

var NUM_SLIMES 
var NUM_SPIDERS 
var NUM_SKELETONS 
var NUM_MUSHROOMS 
var NUM_SMALL_ORE 
var NUM_LARGE_ORE 

var oreTypesLevel2 = ["bronze ore", "bronze ore", "bronze ore", "iron ore", "iron ore", "gold ore"]
var mushroomTypes = ["common mushroom", "healing mushroom", "purple mushroom", "chanterelle"]
var randomAdjacentTiles = [Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]
var _uuid = load("res://helpers/UUID.gd")
var uuid = _uuid.new()

func _ready():
#	level = SceneChanger.cave_level
#	tier = SceneChanger.cave_tier
	name = tier+str(level)
	match tier:
		"wind":
			map_size = 100
			NUM_LARGE_ORE = 6
			NUM_SMALL_ORE = 12
			NUM_MUSHROOMS = 8
			NUM_SPIDERS = 7
			NUM_SLIMES = 7
			NUM_SKELETONS = 7
		"fire":
			map_size = 125
		"ice":
			map_size = 150
	Server.world = self
	Tiles.nav_tiles = $TerrainTiles/ValidTiles
	Tiles.valid_tiles = $TerrainTiles/ValidTiles
	Tiles.cave_wall_tiles = $TerrainTiles/Walls
	Tiles.cave_water_tiles = $TerrainTiles/Freshwater
	Tiles.cave_grass_tiles = $TerrainTiles/Grass
	await get_tree().create_timer(0.5).timeout
	load_cave_terrain() 
	set_valid_tiles()
	set_mobs()
	if MapData.world.has(tier+str(level)):
		load_resources()
	else:
		MapData.world[tier+str(level)] = {
				"tree": {},
				"stump": {},
				"log": {},
				"ore_large": {},
				"ore": {},
				"tall_grass": {},
				"forage": {},
				"animal": {},
				"crop": {},
				"tile": {},
				"placeable": {}}
		generate_random_resources()
	spawn_player()

func generate_random_resources():
	generate_ore()
	generate_mushroom_forage()
	generate_tall_grass()


func load_resources():
	var map = MapData.world[tier+str(level)]
	# ore
	for id in map["ore_large"]:
		var loc = Util.string_to_vector2(map["ore_large"][id]["l"])
		var health = map["ore_large"][id]["h"]
		var variety = map["ore_large"][id]["v"]
		PlaceObject.place_large_ore_in_world(id,variety,loc,health)
		await get_tree().process_frame
	for id in map["ore"]:
		var loc = Util.string_to_vector2(map["ore"][id]["l"])
		var health = map["ore"][id]["h"]
		var variety = map["ore"][id]["v"]
		PlaceObject.place_small_ore_in_world(id,variety,loc,health)
		await get_tree().process_frame
	for id in map["tall_grass"]:
		var loc = Util.string_to_vector2(map["ore"][id]["l"])
		PlaceObject.place_tall_grass_in_world(id,map["tall_grass"][id]["b"],loc,map["tall_grass"][id]["fh"],map["tall_grass"][id]["bh"])
		await get_tree().process_frame
	for id in map["forage"]:
		var location = Util.string_to_vector2(map["forage"][id]["l"])
		var variety = map["forage"][id]["v"]
		PlaceObject.place_forage_in_world(id,variety,location,true)

func set_mobs():
	var locs = valid_tiles.get_used_cells(0)
	locs.shuffle()
	for i in range(NUM_SLIMES):
		var slime = Slime.instantiate()
		$Enemies.call_deferred("add_child", slime)
		slime.position = locs[i]*16 + Vector2i(8,8)
		await get_tree().process_frame
	locs.shuffle()
	for i in range(NUM_SPIDERS):
		var spider = Spider.instantiate()
		$Enemies.call_deferred("add_child", spider)
		spider.position = locs[i]*16 + Vector2i(8,8)
		await get_tree().process_frame
	locs.shuffle()
	for i in range(NUM_SKELETONS):
		var skele = Skeleton.instantiate()
		$Enemies.call_deferred("add_child", skele)
		skele.position = locs[i]*16 + Vector2i(8,8)
		await get_tree().process_frame


func spawn_player():
	print("SPAWN PLAYER")
	$InitLoadingScreen.queue_free()
	var player = Player.instantiate()
	player.name = str("PLAYER")
	player.load_screen_timer = 3.0
	$Players.add_child(player)
	var spawn_loc = $TerrainTiles/UpLadder.get_used_cells(0)[0]
	player.position = Vector2(spawn_loc*16) + Vector2(8,8)


func load_cave_terrain():
	var map = JsonData.cave_data[tier+str(level)]
	# walls
	var walls = Util.convertArrayToVector(map["wall"])
	match tier:
		"wind":
			wall_tiles.set_cells_terrain_connect(0,walls,0,2)
		"fire":
			wall_tiles.set_cells_terrain_connect(0,walls,0,4)
		"ice":
			wall_tiles.set_cells_terrain_connect(0,walls,0,3)
	
	# terrain
	for x in range(map_size+4):
		for y in range(map_size+4):
			match tier:
				"wind":
					$TerrainTiles/Ground1.set_cell(0,Vector2i(x-2,y-2),0,Vector2i(randi_range(26,28),randi_range(40,42)))
				"fire":
					$TerrainTiles/Ground1.set_cell(0,Vector2i(x-2,y-2),0,Vector2i(randi_range(56,58),randi_range(40,42)))
				"ice":
					$TerrainTiles/Ground1.set_cell(0,Vector2i(x-2,y-2),0,Vector2i(randi_range(56,58),randi_range(40,42)))
	
	var g1 = Util.convertArrayToVector(map["ground1"])
	$TerrainTiles/Ground2.set_cells_terrain_connect(0,g1,0,1)
	var g2 = Util.convertArrayToVector(map["ground2"])
	$TerrainTiles/Grass.set_cells_terrain_connect(0,g2,0,0)
	
	# decor
	var r1 = Util.convertArrayToVector(map["rail"])
	$TerrainTiles/Decoration.set_cells_terrain_connect(0,r1,0,0)
	for loc in map["light"]:
		var rand_light = Util.string_to_vector2(map["light"][loc])
		$TerrainTiles/Decoration.set_cell(0,Util.string_to_vector2(loc),0,rand_light)
		var type
		if rand_light.x == 53:
			type = "red"
		elif rand_light.x == 54:
			type = "yellow"
		elif rand_light.x == 55:
			type = "blue"
		var caveLight = CaveLight.instantiate()
		caveLight.type = type
		caveLight.position = Util.string_to_vector2(loc)*16
		$LightObjects.call_deferred("add_child",caveLight)
		
	# ladders and chest
	for ladder in map["ladder"].keys():
		if ladder == "up":
			var loc = Util.string_to_vector2(map["ladder"]["up"])
			$TerrainTiles/UpLadder.set_cell(0,loc,0,Vector2i(60,9))
		else:
			var loc = Util.string_to_vector2(map["ladder"]["down"])
			$TerrainTiles/DownLadder.set_cell(0,loc,0,Vector2i(61,11))
	PlaceObject.place_object_in_world(tier+str(level), "chest", "down", Util.string_to_vector2(map["chest"]), 1, false, true)
	PlayerData.player_data["ui_slots"][tier+str(level)] = return_random_chest_data()


func return_random_chest_data():
	var dict = {}
	var indices = []
	for i in range(2):
		dict[str(randi_range(0,29))] = [return_random_seed(), randi_range(15,50), null]
	return dict

func return_random_seed():
	var crops = JsonData.crop_data.keys()
	crops.shuffle()
	return crops.front() + " seeds"


func set_valid_tiles():
	for y in range(map_size):
		for x in range(map_size):
			var loc = Vector2i(x,y)
			if wall_tiles.get_cell_atlas_coords(0,loc) == Vector2i(-1,-1):
				valid_tiles.set_cell(0,loc,0,Vector2i(0,0))
				nav_tiles.set_cell(0,loc,0,Vector2i(0,0))


func _on_spawn_bat_timer_timeout():
	var spawn_loc
	if Util.chance(25): # top
		spawn_loc = Vector2(randf_range(0,map_size),-10)
	elif Util.chance(25): # bottom
		spawn_loc = Vector2(randf_range(0,map_size),map_size+10)
	elif Util.chance(25): # left
		spawn_loc = Vector2(-10,randf_range(0,map_size))
	else:
		spawn_loc = Vector2(map_size+10,randf_range(0,map_size))
	var bat = Bat.instantiate()
	bat.position = spawn_loc*16
	$Enemies.call_deferred("add_child",bat)
	$SpawnBatTimer.start(randi_range(10,25))


func generate_mushroom_forage():
	for i in range(NUM_MUSHROOMS):
		var loc = Vector2i(randi_range(1,map_size), randi_range(1,map_size))
		if not valid_tiles.get_cell_atlas_coords(0,loc) == Vector2i(-1,-1):
			mushroomTypes.shuffle()
			var id = uuid.v4()
			PlaceObject.place_forage_in_world(id,mushroomTypes.front(),loc,true)
			MapData.world[tier+str(level)]["forage"][id] = {"l": loc, "v": mushroomTypes.front()}
			await get_tree().create_timer(0.1).timeout


func generate_tall_grass():
	for z in range(2):
		for i in range(4):
			var start_loc = Vector2i(randi_range(1,map_size), randi_range(1,map_size))
			if not valid_tiles.get_cell_atlas_coords(0,start_loc) == Vector2i(-1,-1):
				generate_grass_bunch(start_loc, i+1)


func generate_grass_bunch(loc, variety):
	var randomNum = randi_range(40, 100)
	for _i in range(randomNum):
		randomAdjacentTiles.shuffle()
		loc += randomAdjacentTiles[0]
		if not valid_tiles.get_cell_atlas_coords(0,loc) == Vector2i(-1,-1):
			var id = uuid.v4()
			PlaceObject.place_tall_grass_in_world(id,"cave"+str(variety),loc,3,3)
			MapData.world[tier+str(level)]["tall_grass"][id] = {"l": loc, "v": variety, "fh":randi_range(1,3), "bh":randi_range(1,3)}
		else:
			loc -= randomAdjacentTiles[0]



func generate_ore():
	for i in range(NUM_SMALL_ORE):
		var loc = Vector2i(randi_range(1,map_size), randi_range(1,map_size))
		if not valid_tiles.get_cell_atlas_coords(0,loc) == Vector2i(-1,-1):
			var id = uuid.v4()
			oreTypesLevel2.shuffle()
			PlaceObject.place_small_ore_in_world(id,oreTypesLevel2.front(),loc,Stats.SMALL_ORE_HEALTH)
			MapData.world[tier+str(level)]["ore"][id] = {"l": loc, "v": oreTypesLevel2.front(), "h": Stats.SMALL_ORE_HEALTH}
			await get_tree().create_timer(0.1).timeout
	for i in range(NUM_LARGE_ORE):
		var loc = Vector2i(randi_range(1,map_size), randi_range(1,map_size))
		if not valid_tiles.get_cell_atlas_coords(0,loc) == Vector2i(-1,-1) and not valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(-1,0)) == Vector2i(-1,-1) and not valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(-1,-1)) == Vector2i(-1,-1) and not valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,-1)) == Vector2i(-1,-1): 
			var id = uuid.v4()
			oreTypesLevel2.shuffle()
			PlaceObject.place_large_ore_in_world(id,oreTypesLevel2.front(),loc,Stats.LARGE_ORE_HEALTH)
			MapData.world[tier+str(level)]["ore_large"][id] = {"l": loc, "v": oreTypesLevel2.front(), "h": Stats.LARGE_ORE_HEALTH}
			await get_tree().create_timer(0.1).timeout

