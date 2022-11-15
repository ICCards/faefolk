extends YSort

onready var CaveLadder = preload("res://World/Caves/Objects/CaveLadder.tscn")
onready var LargeOre = preload("res://World/Objects/Nature/Ores/LargeOre.tscn")
onready var SmallOre = preload("res://World/Objects/Nature/Ores/SmallOre.tscn")
onready var Mushroom = preload("res://World/Objects/Nature/Forage/Mushroom.tscn")
onready var TallGrass = preload("res://World/Objects/Nature/Grasses/TallGrass.tscn")
onready var CaveGrass = preload("res://World/Caves/Objects/CaveGrass.tscn")
onready var Bat = preload("res://World/Enemies/Slime/Bat.tscn")
onready var CaveLight = preload("res://World/Caves/Objects/CaveLight.tscn")
onready var Player = preload("res://World/Player/Player/Player.tscn")
const _character = preload("res://Global/Data/Characters.gd")
var oreTypes = ["stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "bronze ore", "iron ore", "bronze ore", "iron ore", "gold ore"]
const randomAdjacentTiles = [Vector2(0, 1), Vector2(1, 1), Vector2(-1, 1), Vector2(0, -1), Vector2(-1, -1), Vector2(1, -1), Vector2(1, 0), Vector2(-1, 0)]

var rng = RandomNumberGenerator.new()
const NUM_MUSHROOMS = 20
const NUM_SMALL_ORE = 20
const NUM_LARGE_ORE = 6
const MAX_TALL_GRASS_SIZE = 40
var ore_count = 0

var nav_node

func advance_cave_level():
	for node in self.get_children():
		remove_child(node)
	yield(get_tree(), "idle_frame")
	SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 2/Cave 2.tscn")


func spawnPlayerExample():
	var player = Player.instance()
	player.name = str(get_tree().get_network_unique_id())
	player.character = _character.new()
	player.character.LoadPlayerCharacter("human_male")
	$Players.add_child(player)
	player.spawn_position = Vector2(27*32,7*32)
	player.position =  Vector2(27*32,7*32)
	Server.player_node = player


func _ready():
	nav_node = $Navigation2D
	Tiles.cave_wall_tiles = $Tiles/Walls
	Tiles.valid_tiles = $Tiles/ValidTiles
	Server.world = self
	spawnPlayerExample()
	set_light_nodes()
	set_ore()
	set_tall_grass_nodes()
	set_mushroom_forage()
	set_nav()
	set_cave_ladder()
	yield(get_tree().create_timer(1.0), "timeout")
	Server.isLoaded = true
	
func set_cave_ladder():
	var caveLadder = CaveLadder.instance()
	add_child(caveLadder)
	caveLadder.position = ($Tiles/Ladders.get_used_cells()[0] * 32) + Vector2(32,16)


func set_ore():
	for i in range(NUM_SMALL_ORE):
		var locs = $Tiles/ValidTiles.get_used_cells()
		locs.shuffle()
		var loc = locs[0]
		if Tiles.validate_tiles(loc, Vector2(1,1)):
			Tiles.remove_valid_tiles(loc)
			oreTypes.shuffle()
			var object = SmallOre.instance()
			object.health = Stats.SMALL_ORE_HEALTH
			object.variety = oreTypes.front()
			object.location = loc
			object.position = $Tiles/ValidTiles.map_to_world(loc) + Vector2(16, 24)
			$OreObjects.call_deferred("add_child",object,true)
	while ore_count < NUM_LARGE_ORE:
		var locs = $Tiles/ValidTiles.get_used_cells()
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
			object.position = $Tiles/ValidTiles.map_to_world(loc)
			$OreObjects.call_deferred("add_child",object,true)
		
	
	
func set_mushroom_forage():
	for i in range(NUM_MUSHROOMS):
		var locs = $Tiles/ValidTiles.get_used_cells()
		locs.shuffle()
		var loc = locs[0]
		if Tiles.validate_tiles(loc, Vector2(1,1)):
			Tiles.add_navigation_tiles(loc)
			var mushroom = Mushroom.instance()
			mushroom.location = loc
			mushroom.global_position = Tiles.valid_tiles.map_to_world(loc)
			$ForageObjects.add_child(mushroom)
		
	
func set_valid_tiles():
	for x in range(50):
		for y in range(50):
			if $Tiles/Walls.get_cell(x,y) == -1 and $Tiles/Rail.get_cell(x,y) == -1:
				$Tiles/ValidTiles.set_cell(x,y,0)
			

func set_tall_grass_nodes():
	for i in range(4):
		var locs = $Tiles/ValidTiles.get_used_cells()
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
			call_deferred("add_child", caveGrass)
			caveGrass.position =  $Tiles/ValidTiles.map_to_world(loc) + Vector2(16,32)
		else:
			loc -= randomAdjacentTiles[0]


func set_light_nodes():
	for loc in $Tiles/Lights.get_used_cells():
		var caveLight = CaveLight.instance()
		if $Tiles/Lights.get_cellv(loc) == 0: 
			caveLight.type = "blue"
		elif $Tiles/Lights.get_cellv(loc) == 1: 
			caveLight.type = "red"
		elif $Tiles/Lights.get_cellv(loc) == 2: 
			caveLight.type = "yellow"
		add_child(caveLight)
		caveLight.position = $Tiles/Lights.map_to_world(loc) + Vector2(16,16)
	
func set_nav():
	for x in range(80):
		for y in range(80):
			if $Tiles/ValidTiles.get_cellv(Vector2(x,y)) != -1:
				$Navigation2D/NavTiles.set_cellv(Vector2(x,y), 0)

var count = 0
func _on_SpawnBatTimer_timeout():
	if count < 5:
		var locs = $Tiles/BatSpawnTiles.get_used_cells()
		locs.shuffle()
		var bat = Bat.instance()
		add_child(bat)
		bat.position = locs[0]*32
		count += 1
