extends YSort

onready var dirt = $GeneratedTiles/DirtTiles
onready var plains = $GeneratedTiles/GreenGrassTiles
onready var forest = $GeneratedTiles/DarkGreenGrassTiles
onready var water = $GeneratedTiles/Water
onready var validTiles = $WorldNavigation/ValidTiles
onready var hoed = $FarmingTiles/HoedAutoTiles
onready var watered = $FarmingTiles/WateredAutoTiles
onready var snow = $GeneratedTiles/SnowTiles
onready var ocean = $GeneratedTiles/AnimatedOceanTiles
onready var wetSand = $GeneratedTiles/WetSandBeachBorder
onready var sand = $GeneratedTiles/DrySandTiles
onready var desert = $GeneratedTiles/DesertTiles
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
onready var Bird = preload("res://World/Animals/Bird.tscn")
onready var WateringCanEffect = preload("res://World/Objects/Nature/Effects/WateringCan.tscn")
onready var HoedDirtEffect = preload("res://World/Objects/Nature/Effects/HoedDirt.tscn") 
onready var DirtTrailEffect = preload("res://World/Objects/Nature/Effects/DustTrailEffect.tscn")

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

var active_player = "Players/" + Server.player_id + "/" + Server.player_id

var object_name
var position_of_object
var object_variety
var day_num = 1
var season = "spring"
var valid_spawn_position
var random_rain_storm_position
var random_snow_storm_position

const NUM_DUCKS = 30
const NUM_BUNNIES = 30

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


#func _ready():
#	spawnPlayerExample()
#	Server.isLoaded = true
#	Server.world = self
#	build_valid_tiles()
#	Tiles.valid_tiles = $WorldNavigation/ValidTiles
#	Tiles.hoed_tiles = $FarmingTiles/HoedAutoTiles
#	Tiles.path_tiles = $PlacableTiles/PathTiles
#	Tiles.building_tiles = $PlacableTiles/BuildingTiles
#	Tiles.ocean_tiles = $GeneratedTiles/AnimatedOceanTiles

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
	#player.initialize_camera_limits(Vector2(-64,-160), Vector2(96640, 96640))
	controller.name = str(get_tree().get_network_unique_id())
	player.name = str(get_tree().get_network_unique_id())
	player.character = _character.new()
	#player.character.LoadPlayerCharacter(Server.player["c"])
	player.character.LoadPlayerCharacter("human_male")
	$Players.add_child(controller)
	if Server.player_house_position == null:
		player.position = Server.player["p"]
		#spawnRandomBear(Server.player["p"])
		#spawn_IC_Ghost(Server.player["p"])
	else: 
		player.position = dirt.map_to_world(Server.player_house_position) + Vector2(135, 60)
	spawn_IC_kitty()

	
func spawn_IC_Ghost(loc):
	var ghost = IC_Ghost.instance()
	$Players.add_child(ghost)
	ghost.global_position = loc + Vector2(100, 100)

	
func spawnRandomBear(pos):
	var bear = Bear.instance()
	$Players.add_child(bear)
	bear.global_position = pos + Vector2(100, 100)
	
	
func spawn_IC_kitty():
	var kitty = Player_pet.instance()
	kitty.name = "kittyNode"
	$Players.add_child(kitty, true)
		



func spawnNewPlayer(player):
	pass
#	print("spawn player template")
#	if not player.empty():
#		if not has_node(str(player["id"])):
#			print("spawning new player " + player["c"])
#			print(player["p"])
#			var new_player = Player_template.instance()
#			new_player.position = player["p"]
#			new_player.name = str(player["id"])
#			#new_player.principal = player["principal"]
#			new_player.character = _character.new()
#			new_player.character.LoadPlayerCharacter(player["c"])
#			$Players.add_child(new_player)
			
	
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
	Tiles.valid_tiles = $WorldNavigation/ValidTiles
	Tiles.hoed_tiles = $FarmingTiles/HoedAutoTiles
	Tiles.path_tiles = $PlacableTiles/PathTiles
	Tiles.ocean_tiles = $GeneratedTiles/AnimatedOceanTiles
	Tiles.dirt_tiles = $GeneratedTiles/DirtTiles
	Tiles.building_tiles = $PlacableTiles/BuildingTiles
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
		Tiles.remove_nature_invalid_tiles(loc, "flower")
		var object = FlowerObject.instance()
		object.position = dirt.map_to_world(loc) + Vector2(16, 32)
		$NatureObjects.add_child(object,true)
		if count == 130:
			yield(get_tree().create_timer(0.25), "timeout")
			count = 0
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("loadingScreen").set_phase("Generating world")
	fill_biome_gaps(map)
	set_water_tiles()
	check_and_remove_invalid_autotiles(map)
	update_tile_bitmask_regions()
	get_node("loadingScreen").set_phase("Spawning in")
	Server.player_state = "WORLD"
	print("Map loaded")
#	yield(get_tree().create_timer(8.5), "timeout")
	get_node("loadingScreen").queue_free()
	#spawnPlayer()
	spawnPlayerExample()
	Server.isLoaded = true
	Server.world = self
	spawn_animals()


func update_tile_bitmask_regions():
	dirt.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	snow.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	ocean.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	sand.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	plains.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	forest.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	desert.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	wetSand.update_bitmask_region()


func spawn_animals():
	for i in range(NUM_BUNNIES):
		spawnRandomBunny()
	for i in range(NUM_DUCKS):
		spawnRandomDuck()
	
func set_water_tiles():
	for x in range(300): # fill ocean
		for y in range(300):
			if dirt.get_cell(x, y) == -1 and plains.get_cell(x, y) == -1 and forest.get_cell(x, y) == -1 and snow.get_cell(x, y) == -1 and desert.get_cell(x, y) == -1 and sand.get_cell(x,y) == -1:
				wetSand.set_cell(x, y, 0)
				ocean.set_cell(x, y, 0)
				validTiles.set_cell(x, y, -1)
	for loc in ocean.get_used_cells(): # remove outer layer to show wet sand
		if sand.get_cellv(loc+Vector2(1,0)) != -1 or sand.get_cellv(loc+Vector2(-1,0)) != -1 or sand.get_cellv(loc+Vector2(0,1)) != -1 or sand.get_cellv(loc+Vector2(0,-1)) != -1:
			ocean.set_cellv(loc, -1)
	for x in range(300): # fill empty tiles
		for y in range(300):
			if dirt.get_cell(x, y) == -1 and plains.get_cell(x, y) == -1 and forest.get_cell(x, y) == -1 and snow.get_cell(x, y) == -1 and desert.get_cell(x, y) == -1 and sand.get_cell(x,y) == -1:
				Tiles._set_cell(sand, x, y, 0)
	for cell in ocean.get_used_cells(): # ocean movement effect
		if Tiles.isCenterBitmaskTile(cell, ocean):
			if Util.chance(50):
				$GeneratedTiles/WaveTiles.set_cellv(cell, rng.randi_range(0, 4))
	
func fill_biome_gaps(map):
	for i in range(2):
		for loc in sand.get_used_cells():
			if Tiles.return_neighboring_cells(loc, desert) != 4:
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
		for loc in desert.get_used_cells():
			if Tiles.return_neighboring_cells(loc, desert) != 4:
				desert.set_cellv(loc + Vector2(1, 0), 0)
				desert.set_cellv(loc + Vector2(-1, 0), 0)
				desert.set_cellv(loc + Vector2(0, 1), 0)
				desert.set_cellv(loc + Vector2(0, -1), 0)
	yield(get_tree().create_timer(0.25), "timeout")
	

func check_and_remove_invalid_autotiles(map):
	for i in range(4):
		for cell in plains.get_used_cells(): 
			if not Tiles.isValidAutoTile(cell, plains):
				plains.set_cellv(cell, -1)
		for cell in forest.get_used_cells(): 
			if not Tiles.isValidAutoTile(cell, forest):
				forest.set_cellv(cell, -1)
		for cell in ocean.get_used_cells():
			if not Tiles.isValidAutoTile(cell, ocean):
				ocean.set_cellv(cell, -1)
		for cell in snow.get_used_cells():
			if not Tiles.isValidAutoTile(cell, snow):
				snow.set_cellv(cell, -1)
		for cell in desert.get_used_cells():
			if not Tiles.isValidAutoTile(cell, desert):
				desert.set_cellv(cell, -1)
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
		if has_node(active_player):
			get_node(active_player + "/Camera2D/UserInterface/CurrentTime").update_time(int(world_state["time_elapsed"]))
		if Server.day != new_day and Server.isLoaded:
			Server.day = new_day
			if new_day == false:
				if has_node(active_player):
					pass
					#get_node(active_player).set_night()
			else:
				if has_node(active_player):
					pass
					#watered.clear()
					#get_node(active_player).set_day()
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
				if str(player) == Server.player_id:
					continue
				if Players.has_node(str(player)):
					var player_node = Players.get_node(str(player))
					if world_state_buffer[1]["players"].has(player):
						var new_position = lerp(world_state_buffer[1]["players"][player]["p"], world_state_buffer[2]["players"][player]["p"], interpolation_factor)
						player_node.move(new_position, world_state_buffer[1]["players"][player]["d"])
				else:
					spawnNewPlayer(world_state_buffer[2]["players"][player])
		elif render_time > world_state_buffer[1].t:
			#var extrapolation_factor = float(render_time - world_state_buffer[0]["t"]) / float(world_state_buffer[1]["t"] - world_state_buffer[0]["t"]) - 1.00
			for player in world_state_buffer[1]["players"].keys():
				if str(player) == "t":
					continue
				if str(player) == Server.player_id:
					continue
				if Players.has_node(str(player)):
					pass
					#var position_delta = (Util.string_to_vector2(world_state_buffer[1]["players"][player]["p"]) - Util.string_to_vector2(world_state_buffer[0]["players"][player]["p"]))
					#var new_position = Util.string_to_vector2(world_state_buffer[1]["players"][player]["p"]) + (position_delta * extrapolation_factor)
					#$Players.get_node(str(player)).MovePlayer(new_position, world_state_buffer[1]["players"][player]["d"])


func returnValidSpawnLocation():
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
		$Animals.add_child(bunny)
		
func spawnRandomBird():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var bird = Bird.instance()
		bird.global_position = loc
		$Animals.add_child(bird)
	
func spawnRandomDuck():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var duck = Duck.instance()
		duck.global_position = loc
		$Animals.add_child(duck)

func _on_SpawnEnemyTimer_timeout():
	if has_node("/root/World/Players/" + Server.player_id):
		spawn_IC_Ghost(get_node("/root/World/Players/" + Server.player_id + "/" + Server.player_id).position)
#		print("spawn snake")
#		var snake = Snake.instance()
#		snake.global_position = get_node("/root/World/Players/" + Server.player_id).position + Vector2(rng.randi_range(-500, 500), rng.randi_range(-500, 500))
#		add_child(snake)

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
