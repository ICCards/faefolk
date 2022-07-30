extends YSort

onready var dirt = $GeneratedTiles/DirtTiles
onready var plains = $GeneratedTiles/GreenGrassTiles
onready var forest = $GeneratedTiles/DarkGreenGrassTiles
onready var water = $GeneratedTiles/Water
onready var validTiles = $WorldNavigation/ValidTiles
onready var hoed = $FarmingTiles/HoedAutoTiles
onready var watered = $FarmingTiles/WateredAutoTiles
onready var snow = $GeneratedTiles/SnowTiles
onready var beachBorderTiles = $GeneratedTiles/AnimatedBeachBorder
onready var sandBeachBorderTiles = $GeneratedTiles/SandBeachBorder
onready var desert = $GeneratedTiles/DesertTiles

onready var Player = preload("res://World/Player/Player/Player.tscn")
onready var Player_template = preload("res://World/Player/PlayerTemplate/PlayerTemplate.tscn")
onready var Player_pet = preload("res://World/Player/Pet/PlayerPet.tscn")
onready var Bear = preload("res://World/Animals/Bear.tscn")
onready var Snake = preload("res://World/Animals/Snake.tscn")
onready var IC_Ghost = preload("res://World/Enemies/ICGhost.tscn")
onready var Bunny = preload("res://World/Animals/Bunny.tscn")
onready var Duck = preload("res://World/Animals/Duck.tscn")

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

var object_types = ["tree", "tree stump", "tree branch", "ore large", "ore small"]
var tall_grass_types = ["dark green", "green", "red", "yellow"]
var treeTypes = ['A','B', 'C', 'D', 'E']
var oreTypes = ["Stone", "Cobblestone"]

var object_name
var position_of_object
var object_variety
var day_num = 1
var season = "spring"
var valid_spawn_position
var random_rain_storm_position
var random_snow_storm_position

const NUM_FARM_OBJECTS = 550
const NUM_GRASS_BUNCHES = 150
const NUM_GRASS_TILES = 75
const NUM_FLOWER_TILES = 250
const MAX_GRASS_BUNCH_SIZE = 24
const _character = preload("res://Global/Data/Characters.gd")

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100
var mark_for_despawn = []
var tile_ids = {}

func set_world_invisible():
	$GeneratedTiles.visible = false
	$PlacableTiles.visible = false
	$FarmingTiles.visible = false
	$NatureObjects.visible = false
	get_node("PlacableTiles/" + Server.player_house_id).set_player_inside_house()
	
func set_world_visible():
	$GeneratedTiles.visible = true
	$PlacableTiles.visible = true
	$FarmingTiles.visible = true
	$NatureObjects.visible = true
	get_node("PlacableTiles/" + Server.player_house_id).set_player_outside_house()


func _ready():
	var loadingScreen = LoadingScreen.instance()
	loadingScreen.name = "loadingScreen"
	add_child(loadingScreen)
	get_node("loadingScreen").set_phase("Getting map")
	yield(get_tree().create_timer(1), "timeout")
	Server.generated_map.clear()
	Server.generate_map()
	wait_for_map()
	Server.world = self


func wait_for_map():
	if not Server.generated_map.empty():
		buildMap(Server.generated_map)
	else:
		yield(get_tree().create_timer(0.5), "timeout")
		wait_for_map()

func spawnPlayer():
	print('gettiing player')
	print(Server.player)
	if not Server.player.empty():
		print("My Character")
		print(Server.player["c"])
		var player = Player.instance()
		print(str(Server.player["p"]))
		#player.initialize_camera_limits(Vector2(-64,-160), Vector2(9664, 9664))
		player.name = Server.player_id
		player.principal = Server.player["principal"]
		player.character = _character.new()
		player.character.LoadPlayerCharacter(Server.player["c"])
		$Players.add_child(player)
		if Server.player_house_position == null:
			print("setting position")
			player.position = dirt.map_to_world(Util.string_to_vector2(Server.player["p"]))
		else: 
			player.position = dirt.map_to_world(Server.player_house_position) + Vector2(135, 60)
		
func spawnPlayerExample(pos):
	var player = Player.instance()
	#player.initialize_camera_limits(Vector2(-64,-160), Vector2(96640, 96640))
	player.name = Server.player_id
	player.character = _character.new()
	player.character.LoadPlayerCharacter(Server.character)
	$Players.add_child(player)
	if Server.player_house_position == null:
		var loc = Util.string_to_vector2(pos)
		player.position = loc * 32
		#spawn_IC_Ghost(loc)
		#spawnRandomBear(loc)
	else: 
		player.position = dirt.map_to_world(Server.player_house_position) + Vector2(135, 60)
	#spawn_IC_kitty()

	
func spawn_IC_Ghost(loc):
	var ghost = IC_Ghost.instance()
	$Players.add_child(ghost)
	ghost.global_position = loc * 32 + Vector2(100, 100)

	
func spawnRandomBear(loc):
	var bear = Bear.instance()
	$Players.add_child(bear)
	bear.global_position = loc * 32 + Vector2(100, 100)
	
	
func spawn_IC_kitty():
	var kitty = Player_pet.instance()
	kitty.name = "kittyNode"
	$Players.add_child(kitty, true)
		
func get_valid_player_spawn_position():
	rng.randomize()
	var randomLoc = Vector2(rng.randi_range(2, 298), rng.randi_range(2, 298))
	if validTiles.get_cellv(randomLoc) != -1:
		valid_spawn_position = dirt.map_to_world(randomLoc)
	else:
		get_valid_player_spawn_position()
		

func spawnNewPlayer(player):
	if not player.empty():
		if not has_node(str(player["id"])):
			print("spawning new player")
			print(player["p"])
			var new_player = Player_template.instance()
			new_player.position = dirt.map_to_world(Util.string_to_vector2(player["p"]))
			new_player.name = str(player["id"])
			new_player.principal = player["principal"]
			new_player.character = _character.new()
			new_player.character.LoadPlayerCharacter(player["c"])
			$Players.add_child(new_player)
			
	
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
	build_valid_tiles()
	print("BUILDING MAP")
	get_node("loadingScreen").set_phase("Building terrain")
	for id in map["dirt"]:
		var loc = Util.string_to_vector2(map["dirt"][id])
		var x = loc.x
		var y = loc.y
		tile_ids["" + str(x) + "" + str(y)] = id
#		if map["dirt"][id]["isWatered"]:
#			watered.set_cellv(loc, 0)
#			hoed.set_cellv(loc, 0)
#		if map["dirt"][id]["isHoed"]:
#			hoed.set_cellv(loc, 0)
		dirt.set_cellv(loc, 0)
	hoed.update_bitmask_region()
	watered.update_bitmask_region()
	print("LOADED DIRT")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["plains"]:
		var loc = Util.string_to_vector2(map["plains"][id])
		plains.set_cellv(loc, 0)
	print("LOADED PLAINS")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["forest"]:
		var loc = Util.string_to_vector2(map["forest"][id])
		forest.set_cellv(loc, 0)
	print("LOADED DG")
	get_node("loadingScreen").set_phase("Building trees")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["snow"]:
		var loc = Util.string_to_vector2(map["snow"][id])
		snow.set_cellv(loc, 0)
	for id in map["desert"]:
		var loc = Util.string_to_vector2(map["desert"][id])
		desert.set_cellv(loc, 0)
	for id in map["beach"]:
		var loc = Util.string_to_vector2(map["beach"][id])
		sandBeachBorderTiles.set_cellv(loc, 0)
	for id in map["tree"]:
		var loc = Util.string_to_vector2(map["tree"][id]["l"])
		set_valid_tiles(loc, "tree")
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
		var loc = Util.string_to_vector2(map["log"][id]["l"])
		set_valid_tiles(loc)
		rng.randomize()
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
		var loc = Util.string_to_vector2(map["stump"][id]["l"])
		set_valid_tiles(loc, "stump")
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
		var loc = Util.string_to_vector2(map["ore_large"][id]["l"])
		set_valid_tiles(loc, "large ore")
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
		var loc = Util.string_to_vector2(map["ore"][id]["l"])
		set_valid_tiles(loc)
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
		var loc = Util.string_to_vector2(map["tall_grass"][id]["l"])
		#set_valid_tiles(loc)
		count += 1
		var object = TallGrassObject.instance()
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
		var loc = Util.string_to_vector2(map["flower"][id]["l"])
		#set_valid_tiles(loc)
		var object = FlowerObject.instance()
		object.position = dirt.map_to_world(loc) + Vector2(16, 32)
		$NatureObjects.add_child(object,true)
		if count == 130:
			yield(get_tree().create_timer(0.25), "timeout")
			count = 0
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("loadingScreen").set_phase("Generating world")
	fill_biome_gaps(map)
	yield(get_tree().create_timer(1.0), "timeout")
	check_and_remove_invalid_autotiles(map)
	yield(get_tree().create_timer(1.0), "timeout")
	set_water_tiles()
	get_node("loadingScreen").set_phase("Spawning in")
	yield(get_tree().create_timer(1.0), "timeout")
	Server.player_state = "WORLD"
	print("Map loaded")
	Server.world = self
	#yield(get_tree().create_timer(8.5), "timeout")
	get_node("loadingScreen").queue_free()
	#spawnPlayer()
	spawnPlayerExample(map["beach"][map["beach"].keys()[rng.randi_range(0, map["beach"].size() - 1)]])
	Server.isLoaded = true
	spawn_animals()
	
#	spawnRandomSnake()
#	yield(get_tree().create_timer(rand_range(0.1, 1.0)), "timeout")
#	spawnRandomSnake()
#	yield(get_tree().create_timer(rand_range(0.1, 1.0)), "timeout")
#	spawnRandomSnake()
#	yield(get_tree().create_timer(rand_range(0.1, 1.0)), "timeout")
#	spawnRandomSnake()
#	spawnRandomSnake()
#	spawnRandomSnake()


func spawn_animals():
	for i in range(300):
		spawnRandomBunny()
	for i in range(300):
		spawnRandomDuck()
	
	
func set_valid_tiles(_pos, _name = ""):
	if _name == "tree" or _name == "stump" or _name == "large ore":
		validTiles.set_cellv(_pos, -1)
		validTiles.set_cellv(_pos + Vector2(-1, -1), -1 )
		validTiles.set_cellv(_pos + Vector2(-1, 0), -1 )
		validTiles.set_cellv(_pos + Vector2(0, -1), -1)
	else:
		validTiles.set_cellv(_pos, -1)
		
	
func set_water_tiles():
	for x in range(1000):
		for y in range(1000):
			if dirt.get_cell(x, y) == -1 and plains.get_cell(x, y) == -1 and forest.get_cell(x, y) == -1 and snow.get_cell(x, y) == -1 and desert.get_cell(x, y) == -1 and sandBeachBorderTiles.get_cell(x,y) == -1:
				beachBorderTiles.set_cell(x, y, 0)
				sandBeachBorderTiles.set_cell(x, y, 0)
				validTiles.set_cell(x, y, -1)
	for i in range(2):
		for loc in sandBeachBorderTiles.get_used_cells():
			if Tiles.return_neighboring_cells(loc, beachBorderTiles) != 4:
				sandBeachBorderTiles.set_cellv(loc + Vector2(1, 0), 0)
				sandBeachBorderTiles.set_cellv(loc + Vector2(-1, 0), 0)
				sandBeachBorderTiles.set_cellv(loc + Vector2(0, 1), 0)
				sandBeachBorderTiles.set_cellv(loc + Vector2(0, -1), 0)
	for i in range(2):
		for cell in beachBorderTiles.get_used_cells():
				if Tiles.return_neighboring_cells(cell, beachBorderTiles) <= 1:
					beachBorderTiles.set_cellv(cell, -1)
					sandBeachBorderTiles.set_cellv(cell, 0)
	for cell in beachBorderTiles.get_used_cells():
		if Tiles.isCenterBitmaskTile(cell, beachBorderTiles):
			if Util.chance(50):
				rng.randomize()
				$GeneratedTiles/WaveTiles.set_cellv(cell, rng.randi_range(0, 4))
	beachBorderTiles.update_bitmask_region()
	sandBeachBorderTiles.update_bitmask_region()
	
func fill_biome_gaps(map):
	for i in range(2):
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
		for loc in desert.get_used_cells():
			if Tiles.return_neighboring_cells(loc, desert) != 4:
				desert.set_cellv(loc + Vector2(1, 0), 0)
				desert.set_cellv(loc + Vector2(-1, 0), 0)
				desert.set_cellv(loc + Vector2(0, 1), 0)
				desert.set_cellv(loc + Vector2(0, -1), 0)
		#yield(get_tree().create_timer(1.0), "timeout")
	

func check_and_remove_invalid_autotiles(map):
	for i in range(4):
		for cell in plains.get_used_cells(): 
			if not Tiles.isValidAutoTile(cell, plains):
				plains.set_cellv(cell, -1)
		for cell in forest.get_used_cells(): 
			if not Tiles.isValidAutoTile(cell, forest):
				forest.set_cellv(cell, -1)
		for cell in beachBorderTiles.get_used_cells():
			if not Tiles.isValidAutoTile(cell, beachBorderTiles):
				beachBorderTiles.set_cellv(cell, -1)
		for cell in snow.get_used_cells():
			if not Tiles.isValidAutoTile(cell, snow):
				snow.set_cellv(cell, -1)
		for cell in desert.get_used_cells():
			if not Tiles.isValidAutoTile(cell, desert):
				desert.set_cellv(cell, -1)
		for cell in dirt.get_used_cells():
			if not Tiles.isValidAutoTile(cell, dirt):
				dirt.set_cellv(cell, -1)
		yield(get_tree().create_timer(1.0), "timeout")
	dirt.update_bitmask_region()
	snow.update_bitmask_region()
	beachBorderTiles.update_bitmask_region()
	sandBeachBorderTiles.update_bitmask_region()
	plains.update_bitmask_region()
	forest.update_bitmask_region()
	desert.update_bitmask_region()

func build_valid_tiles():
	for x in range(1000):
		for y in range(1000):
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


func UpdateWorldState(world_state):
#	if Server.day == null:
#		if get_node("Players").has_node(Server.player_id):
#			get_node("Players/" + Server.player_id).init_day_night_cycle(int(world_state["time_elapsed"]))
	if world_state["t"] > last_world_state:
		var new_day = bool(world_state["day"])
		if has_node("Players/" + Server.player_id):
			get_node("Players/" + Server.player_id + "/Camera2D/UserInterface/CurrentTime").update_time(int(world_state["time_elapsed"]))
		if Server.day != new_day and Server.isLoaded:
			Server.day = new_day
			if new_day == false:
				if has_node("Players/" + Server.player_id):
					get_node("Players/" + Server.player_id).set_night()
			else:
				if has_node("Players/" + Server.player_id):
					watered.clear()
					get_node("Players/" + Server.player_id).set_day()
		last_world_state = world_state["t"]
		world_state_buffer.append(world_state)


func _physics_process(delta):
	var render_time = OS.get_system_time_msecs() - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].t:
			world_state_buffer.remove(0)
		if world_state_buffer.size() > 2:
			for decoration in world_state_buffer[2]["decorations"].keys():
				match decoration:
					"seed":
						for item in world_state_buffer[2]["decorations"][decoration].keys():
							var data = world_state_buffer[2]["decorations"][decoration][item]
							if has_node(str(item)):
								get_node(str(item)).days_until_harvest = data["d"]
								get_node(str(item)).refresh_image()
			var interpolation_factor = float(render_time - world_state_buffer[1]["t"]) / float(world_state_buffer[2]["t"] - world_state_buffer[1]["t"])
			for player in world_state_buffer[2]["players"].keys():
				if str(player) == "t":
					continue
				if player == Server.player_id:
					continue
				if $Players.has_node(str(player)):
					if world_state_buffer[1]["players"].has(player):
						var new_position = lerp(Util.string_to_vector2(world_state_buffer[1]["players"][player]["p"]), Util.string_to_vector2(world_state_buffer[2]["players"][player]["p"]), interpolation_factor)
						$Players.get_node(str(player)).MovePlayer(new_position, world_state_buffer[1]["players"][player]["d"])
				else:
					if not mark_for_despawn.has(player):
						print("will spawn player")
						spawnNewPlayer(world_state_buffer[2]["players"][player])
		elif render_time > world_state_buffer[1].t:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["t"]) / float(world_state_buffer[1]["t"] - world_state_buffer[0]["t"]) - 1.00
			for player in world_state_buffer[1]["players"].keys():
				if str(player) == "t":
					continue
				if player == Server.player_id:
					continue
				if $Players.has_node(str(player)):
					var position_delta = (Util.string_to_vector2(world_state_buffer[1]["players"][player]["p"]) - Util.string_to_vector2(world_state_buffer[0]["players"][player]["p"]))
					var new_position = Util.string_to_vector2(world_state_buffer[1]["players"][player]["p"]) + (position_delta * extrapolation_factor)
					$Players.get_node(str(player)).MovePlayer(new_position, world_state_buffer[1]["players"][player]["d"])


func returnValidSpawnLocation():
	rng.randomize()
	var tempLoc = Vector2(rng.randi_range(0, 32000), rng.randi_range(0, 32000))
	if validTiles.get_cellv(validTiles.world_to_map(tempLoc)) != -1:
		return tempLoc
	else:
		return null

func spawnRandomSnake():
	var snake = Snake.instance()
	snake.global_position = get_node("/root/World/Players/" + Server.player_id).position + Vector2(rng.randi_range(-500, 500), rng.randi_range(-500, 500))
	add_child(snake)
	
func spawnRandomBunny():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var bunny = Bunny.instance()
		bunny.global_position = loc
		add_child(bunny)
	
func spawnRandomDuck():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var duck = Duck.instance()
		duck.global_position = loc
		add_child(duck)

func _on_SpawnEnemyTimer_timeout():
	if has_node("/root/World/Players/" + Server.player_id):
		print("spawn snake")
		var snake = Snake.instance()
		snake.global_position = get_node("/root/World/Players/" + Server.player_id).position + Vector2(rng.randi_range(-500, 500), rng.randi_range(-500, 500))
		add_child(snake)
