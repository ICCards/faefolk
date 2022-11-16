extends Node

onready var Slime = preload("res://World/Enemies/Slime/Slime.tscn")
onready var Spider = preload("res://World/Enemies/Spider.tscn")
onready var FireMageSkeleton = preload("res://World/Enemies/Skeleton.tscn")
onready var TileObjectHurtBox = preload("res://World/Objects/Tiles/TileObjectHurtBox.tscn")
onready var CaveLadder = preload("res://World/Caves/Objects/CaveLadder.tscn")
onready var LargeOre = preload("res://World/Objects/Nature/Ores/LargeOre.tscn")
onready var SmallOre = preload("res://World/Objects/Nature/Ores/SmallOre.tscn")
onready var Mushroom = preload("res://World/Objects/Nature/Forage/Mushroom.tscn")
onready var TallGrass = preload("res://World/Objects/Nature/Grasses/TallGrass.tscn")
onready var CaveGrass = preload("res://World/Caves/Objects/CaveGrass.tscn")
onready var CaveLight = preload("res://World/Caves/Objects/CaveLight.tscn")
onready var Player = preload("res://World/Player/Player/Player.tscn")
const _character = preload("res://Global/Data/Characters.gd")
var oreTypes = ["stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "bronze ore", "iron ore", "bronze ore", "iron ore", "gold ore"]
const randomAdjacentTiles = [Vector2(0, 1), Vector2(1, 1), Vector2(-1, 1), Vector2(0, -1), Vector2(-1, -1), Vector2(1, -1), Vector2(1, 0), Vector2(-1, 0)]

var rng = RandomNumberGenerator.new()
const NUM_MUSHROOMS = 20
const NUM_SMALL_ORE = 20
const NUM_LARGE_ORE = 6
const MAX_TALL_GRASS_SIZE = 60
var ore_count = 0
var nav_node

var cave_level_5_dict = {}

var valid_tiles


func spawn_player():
	var spawn_loc = Server.world.get_node("Tiles/UpLadder").get_used_cells()[0]
	var player = Player.instance()
	player.name = str(get_tree().get_network_unique_id())
	player.character = _character.new()
	player.character.LoadPlayerCharacter("human_male")
	Server.world.get_node("Players").add_child(player)
	player.spawn_position = (spawn_loc*32)+Vector2(16,32)
	player.position =  (spawn_loc*32)+Vector2(16,32)
	Server.player_node = player

func build():
	valid_tiles = Server.world.get_node("Tiles/ValidTiles")
	spawn_player()
	set_chest()
	set_light_nodes()
	set_ore()
	set_tall_grass_nodes()
	set_mushroom_forage()
	set_down_cave_ladder()
	spawn_enemies_randomly()
	set_nav()


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
	
	
func set_chest():
	var id = rand_range(0,10000)
	var direction = return_chest_direction(Server.world.get_node("Tiles/Chests").get_used_cells()[0])
	var loc = Server.world.get_node("Tiles/Chests").get_used_cells()[0]
	var tileObjectHurtBox = TileObjectHurtBox.instance()
	tileObjectHurtBox.name = str(id)
	tileObjectHurtBox.is_preset_object_string = Server.world.cave_chest_id
	tileObjectHurtBox.item_name = "stone chest"
	tileObjectHurtBox.location = loc
	tileObjectHurtBox.direction = direction
	Server.world.get_node("PlacableObjects").call_deferred("add_child", tileObjectHurtBox, true)
	tileObjectHurtBox.global_position = Tiles.valid_tiles.map_to_world(Server.world.get_node("Tiles/Chests").get_used_cells()[0]) + Vector2(0,32)
	Server.world.get_node("Tiles/Chests").clear()

func return_chest_direction(loc):
	var type = Server.world.get_node("Tiles/Chests").get_cellv(loc)
	if type == 0:
		return "down"
	elif type == 2:
		return "left"
	elif type == 1:
		return "right"

func set_nav():
	for x in range(80):
		for y in range(80):
			if valid_tiles.get_cellv(Vector2(x,y)) != -1:
				Server.world.get_node("Navigation2D/NavTiles").set_cellv(Vector2(x,y), 0)

func set_down_cave_ladder():
	var caveLadder = CaveLadder.instance()
	Server.world.add_child(caveLadder)
	caveLadder.position = (Server.world.get_node("Tiles/DownLadder").get_used_cells()[0] * 32) + Vector2(32,16)

func set_mushroom_forage():
	for i in range(NUM_MUSHROOMS):
		var locs = valid_tiles.get_used_cells()
		locs.shuffle()
		var loc = locs[0]
		if Tiles.validate_tiles(loc, Vector2(1,1)):
			Tiles.add_navigation_tiles(loc)
			var mushroom = Mushroom.instance()
			mushroom.location = loc
			mushroom.global_position = Tiles.valid_tiles.map_to_world(loc)
			Server.world.get_node("ForageObjects").add_child(mushroom)
	
func set_tall_grass_nodes():
	for i in range(4):
		var locs = valid_tiles.get_used_cells()
		locs.shuffle()
		var start_loc = locs[0]
		create_grass_bunch(start_loc, i+1)
		
func create_grass_bunch(loc, variety):
	rng.randomize()
	var randomNum = rng.randi_range(20, MAX_TALL_GRASS_SIZE)
	for _i in range(randomNum):
		randomAdjacentTiles.shuffle()
		loc += randomAdjacentTiles[0]
		if Tiles.valid_tiles.get_cellv(loc) == 0:
			Tiles.add_navigation_tiles(loc)
			var caveGrass = CaveGrass.instance()
			caveGrass.variety = variety
			caveGrass.loc = loc
			Server.world.get_node("GrassObjects").call_deferred("add_child", caveGrass)
			caveGrass.position = loc*32 + Vector2(16,32)
		else:
			loc -= randomAdjacentTiles[0]
	
	
func set_ore():
	for i in range(NUM_SMALL_ORE):
		var locs = valid_tiles.get_used_cells()
		locs.shuffle()
		var loc = locs[0]
		if Tiles.validate_tiles(loc, Vector2(1,1)):
			Tiles.remove_valid_tiles(loc)
			oreTypes.shuffle()
			var object = SmallOre.instance()
			object.health = Stats.SMALL_ORE_HEALTH
			object.variety = oreTypes.front()
			object.location = loc
			object.position = loc*32 + Vector2(16, 24)
			Server.world.get_node("OreObjects").call_deferred("add_child",object,true)
	while ore_count < NUM_LARGE_ORE:
		var locs = valid_tiles.get_used_cells()
		locs.shuffle()
		var loc = locs[0]
		if Tiles.validate_tiles(loc+Vector2(-1,0), Vector2(2,2)):
			ore_count += 1
			Tiles.remove_valid_tiles(loc+Vector2(-1,0), Vector2(2,2))
			oreTypes.shuffle()
			var object = LargeOre.instance()
			object.health = Stats.LARGE_ORE_HEALTH
			object.variety = oreTypes.front()
			object.location = loc
			object.position = loc*32
			Server.world.get_node("OreObjects").call_deferred("add_child",object,true)

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

