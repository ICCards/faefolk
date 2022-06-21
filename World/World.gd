extends YSort

onready var sand = $GeneratedTiles/SandTiles
onready var grass = $GeneratedTiles/GreenGrassTiles
onready var darkGrass = $GeneratedTiles/DarkGreenGrassTiles
onready var water = $GeneratedTiles/Water
onready var border = $GeneratedTiles/BorderTiles
onready var validTiles = $GeneratedTiles/ValidTiles
onready var fence = $PlacableTiles/FenceTiles
onready var objects = $PlacableTiles/ObjectTiles
onready var path = $PlacableTiles/PathTiles
onready var hoed = $FarmingTiles/HoedAutoTiles
onready var watered = $FarmingTiles/WateredAutoTiles

onready var Player = preload("res://World/Player/Player.tscn")
onready var Player_template = preload("res://World/Player/PlayerTemplate.tscn")

onready var TreeObject = preload("res://World/Objects/Nature/Trees/TreeObject.tscn")
onready var BranchObject = preload("res://World/Objects/Nature/Trees/TreeBranchObject.tscn")
onready var StumpObject = preload("res://World/Objects/Nature/Trees/TreeStumpObject.tscn")
onready var OreObject = preload("res://World/Objects/Nature/Ores/OreObjectLarge.tscn")
onready var SmallOreObject = preload("res://World/Objects/Nature/Ores/OreObjectSmall.tscn")
onready var TallGrassObject = preload("res://World/Objects/Nature/Grasses/TallGrassObject.tscn")
onready var FlowerObject = preload("res://World/Objects/Nature/Grasses/FlowerObject.tscn")
onready var TorchObject = preload("res://World/Objects/AnimatedObjects/TorchObject.tscn")
onready var PlantedCrop  = preload("res://World/Objects/Farm/PlantedCrop.tscn")
onready var TileObjectHurtBox = preload("res://World/PlayerFarm/TileObjectHurtBox.tscn")
onready var LoadingScreen = preload("res://MainMenu/LoadingScreen.tscn")
onready var PlayerHouse = preload("res://World/Objects/Farm/PlayerHouse.tscn")
onready var PlayerHouseTemplate = preload("res://World/Objects/Farm/PlayerHouseTemplate.tscn")
var rng = RandomNumberGenerator.new()


var object_types = ["tree", "tree stump", "tree branch", "ore large", "ore small"]
var tall_grass_types = ["dark green", "green", "red", "yellow"]
var treeTypes = ['A','B', 'C', 'D', 'E']
var oreTypes = ["Stone", "Cobblestone"]
var randomBorderTiles = [Vector2(0, 1), Vector2(1, 1), Vector2(-1, 1), Vector2(0, -1), Vector2(-1, -1), Vector2(1, -1), Vector2(1, 0), Vector2(-1, 0)]

var object_name
var position_of_object
var object_variety
var day = true
var day_num = 1
var season = "spring"

const NUM_FARM_OBJECTS = 550
const NUM_GRASS_BUNCHES = 150
const NUM_GRASS_TILES = 75
const NUM_FLOWER_TILES = 250
const MAX_GRASS_BUNCH_SIZE = 24
const _character = preload("res://Global/Data/Characters.gd")

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100
var decorations = []
var mark_for_despawn = []
var tile_ids = {}

func _ready():
	var loadingScreen = LoadingScreen.instance()
	loadingScreen.name = "loadingScreen"
	add_child(loadingScreen)
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


func spawnPlayer(value):
	print('gettiing player')
	if not value.empty():
		print("My Character")
		print(value["c"])
		var player = Player.instance()
		#player.initialize_camera_limits(Vector2(0, 0), Vector2(1920, 1080))
		print(str(value["p"]))
		player.initialize_camera_limits(Vector2(-64,-160), Vector2(9664, 9664))
		player.name = str(value["id"])
		player.character = _character.new()
		player.character.LoadPlayerCharacter(value["c"]) 
		$Players.add_child(player)
		if Server.player_house_position == null:
			player.position = sand.map_to_world(value["p"]) + Vector2(1000, 800)
		else: 
			player.position = sand.map_to_world(Server.player_house_position) + Vector2(135, 60)
		print('getting map')
		
		
func spawnNewPlayer(player):
	if not player.empty():
		if not has_node(str(player["id"])):
			print("spawning new player")
			print(player["p"])
			var new_player = Player_template.instance()
			new_player.position = sand.map_to_world(player["p"])
			new_player.name = str(player["id"])
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
	for id in map["dirt"]:
		var x = map["dirt"][id]["l"].x
		var y = map["dirt"][id]["l"].y
		tile_ids["" + str(x) + "" + str(y)] = id
		if map["dirt"][id]["isWatered"]:
			watered.set_cellv(map["dirt"][id]["l"], 0)
			hoed.set_cellv(map["dirt"][id]["l"], 0)
		if map["dirt"][id]["isHoed"]:
			hoed.set_cellv(map["dirt"][id]["l"], 0)
		if Util.chance(5):
			_set_cell( sand, x, y, 1 )
		else:
			_set_cell( sand, x, y, 0 )
	hoed.update_bitmask_region()
	watered.update_bitmask_region()
	print("LOADED DIRT")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["dark_grass"]:
		_set_cell(sand, map["dark_grass"][id].x, map["dark_grass"][id].y, 0)
		grass.set_cellv(map["dark_grass"][id], 0)
	print("LOADED GRASS")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["grass"]:
		grass.set_cellv(map["grass"][id], 0)
		darkGrass.set_cellv(map["grass"][id], 0)
	print("LOADED DG")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["water"]:
		validTiles.set_cellv(map["water"][id], -1)
		darkGrass.set_cellv(map["water"][id], 0)
		water.set_cellv(map["water"][id], 0)
	print("LOADED WATER")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["tree"]:
		if is_valid_position(map["tree"][id]["l"], "tree"):
			validTiles.set_cellv(map["tree"][id]["l"], -1)
			validTiles.set_cellv(map["tree"][id]["l"] + Vector2(-1, 0), -1)
			validTiles.set_cellv(map["tree"][id]["l"] + Vector2(-1, -1), -1)
			validTiles.set_cellv(map["tree"][id]["l"] + Vector2(0, -1), -1)
			treeTypes.shuffle()
			var variety = treeTypes.front()
			var object = TreeObject.instance()
			object.health = map["tree"][id]["h"]
			object.initialize(variety, map["tree"][id])
			object.position = sand.map_to_world(map["tree"][id]["l"]) + Vector2(0, -8)
			object.name = id
			add_child(object,true)
	print("LOADED TREES")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["log"]:
		if is_valid_position(map["log"][id]["l"], "log"):
			validTiles.set_cellv(map["log"][id]["l"], -1)
			rng.randomize()
			var variety = rng.randi_range(0, 11)
			var object = BranchObject.instance()
			object.name = id
			object.health = map["log"][id]["h"]
			object.initialize(variety, map["log"][id]["l"])
			object.position = sand.map_to_world(map["log"][id]["l"]) + Vector2(16, 16)
			add_child(object,true)
	print("LOADED LOGS")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["stump"]:
		if is_valid_position(map["stump"][id]["l"], "stump"):
			validTiles.set_cellv(map["stump"][id]["l"], -1)
			validTiles.set_cellv(map["stump"][id]["l"] + Vector2(-1, 0), -1)
			validTiles.set_cellv(map["stump"][id]["l"] + Vector2(-1, -1), -1)
			validTiles.set_cellv(map["stump"][id]["l"] + Vector2(0, -1), -1)
			treeTypes.shuffle()
			var variety = treeTypes.front()
			var object = StumpObject.instance()
			object.health = map["stump"][id]["h"]
			object.name = id
			object.initialize(variety,map["stump"][id]["l"])
			object.position = sand.map_to_world(map["stump"][id]["l"]) + Vector2(4,0)
			add_child(object,true)
	print("LOADED STUMPS")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["ore_large"]:
		print('spawn large ore if good loc')
		if is_valid_position(map["ore_large"][id]["l"], "ore_large"):
			validTiles.set_cellv(map["ore_large"][id]["l"], -1)
			oreTypes.shuffle()
			var variety = oreTypes.front()
			var object = OreObject.instance()
			object.health = map["ore_large"][id]["h"]
			object.name = id
			object.initialize(variety,map["ore_large"][id]["l"],true)
			object.position = sand.map_to_world(map["ore_large"][id]["l"]) 
			add_child(object,true)
	print("LOADED LARGE OrE")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["ore"]:
		if is_valid_position(map["ore"][id]["l"], "ore"):
			validTiles.set_cellv(map["ore"][id]["l"], -1)
			oreTypes.shuffle()
			var variety = oreTypes.front()
			var object = SmallOreObject.instance()
			object.health = map["ore"][id]["h"]
			object.name = id
			object.initialize(variety,map["ore"][id]["l"])
			object.position = sand.map_to_world(map["ore"][id]["l"]) + Vector2(16, 24)
			add_child(object,true)
	print("LOADED OrE")
	yield(get_tree().create_timer(0.5), "timeout")
	var count = 0
	for id in map["tall_grass"]:
		if is_valid_position(map["tall_grass"][id]["l"], "tall_grass"):
			validTiles.set_cellv(map["tall_grass"][id]["l"], -1)
			count += 1
			tall_grass_types.shuffle()
			var variety = tall_grass_types.front()
			var object = TallGrassObject.instance()
			object.name = id
			object.initialize(variety)
			object.position = sand.map_to_world(map["tall_grass"][id]["l"]) + Vector2(16, 32)
			add_child(object,true)
		if count == 130:
			yield(get_tree().create_timer(0.2), "timeout")
			count = 0
	print("LOADED TALL GRASS")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["flower"]:
		if is_valid_position(map["flower"][id]["l"], "flower"):
			validTiles.set_cellv(map["flower"][id]["l"], -1)
			var object = FlowerObject.instance()
			object.position = sand.map_to_world(map["flower"][id]["l"]) + Vector2(16, 32)
			add_child(object,true)
	print("LOADED FLOWERS")
#	for key in map["decorations"].keys():
#		match key:
#			"seed":
#				for id in map["decorations"][key].keys():
#					PlaceSeedInWorld(id, map["decorations"][key][id]["n"], map["decorations"][key][id]["l"], map["decorations"][key][id]["d"])
#			"placable": 
#				for id in map["decorations"][key].keys():
#					PlaceItemInWorld(id, map["decorations"][key][id]["n"], map["decorations"][key][id]["l"])
	print("LOADED OBJECTS")
	yield(get_tree().create_timer(0.5), "timeout")
	check_and_remove_invalid_autotiles(map)
	generate_border_tiles()
	yield(get_tree().create_timer(0.5), "timeout")
	border.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	grass.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	darkGrass.update_bitmask_region()
	yield(get_tree().create_timer(0.5), "timeout")
	water.update_bitmask_region()
	Server.player_state = "WORLD"
	Server.isLoaded = true
#	if !DayNightTimer.is_timer_started:
#		DayNightTimer.is_timer_started = true
#		DayNightTimer.start_day_timer()
	print("Map loaded")
	get_node("loadingScreen").queue_free()
	spawnPlayer(Server.player)
	
	
func build_valid_tiles():
	for x in range(298):
		for y in range(298):
			validTiles.set_cellv(Vector2(x+1, y+1), 0)
	
func is_valid_position(_pos, _name):
	if _pos.x > 1 and _pos.x < 299 and _pos.y > 1 and _pos.y < 299:
		if validTiles.get_cellv(_pos) != -1:
			if (_name == "tree" or _name == "stump") and \
				validTiles.get_cellv(_pos + Vector2(-1, -1)) == -1 or \
				validTiles.get_cellv(_pos + Vector2(-1, 0)) == -1 or \
				validTiles.get_cellv(_pos + Vector2(0, -1)) == -1:
				return false
			else:
				return true
		else: 
			return false
	else: 
		return false
	
		
func generate_border_tiles():
	for i in range(300):
		border.set_cellv(Vector2(i, -3), 0)
		border.set_cellv(Vector2(0, i), 1)
		border.set_cellv(Vector2(299, i), 2)
		border.set_cellv(Vector2(i, 299), 3)
	border.set_cellv(Vector2(0, 299), 3)
	
	for i in range(306):
		_set_cell(border, i-2, -4, 4)
		_set_cell(border, i-2, -5, 4)
		_set_cell(border, i-2, 300, 4)
		_set_cell(border, i-2, 301, 4)
		_set_cell(border, -1, i-3, 4)
		_set_cell(border, -2, i-3, 4)
		_set_cell(border, 300, i-3, 4)
		_set_cell(border, 301, i-3, 4)
		
	
	
func check_and_remove_invalid_autotiles(map):
	for i in range(2):
		for id in map["grass"]: 
			if return_neighboring_cells(map["grass"][id], darkGrass) <= 1:
				darkGrass.set_cellv(map["grass"][id], -1)
		for id in map["dark_grass"]: 
			if return_neighboring_cells(map["dark_grass"][id], grass) <= 1:
				grass.set_cellv(map["dark_grass"][id], -1)
		for id in map["water"]:
			if return_neighboring_cells(map["water"][id], water) <= 1:
				water.set_cellv(map["water"][id], -1)
		yield(get_tree().create_timer(0.5), "timeout")
		
func return_neighboring_cells(_pos, _map):
	var count = 0
	if _map.get_cellv(_pos + Vector2(0,1)) != -1:
		count += 1
	if _map.get_cellv(_pos + Vector2(0,-1)) != -1:
		count += 1
	if _map.get_cellv(_pos + Vector2(1,0)) != -1:
		count += 1
	if _map.get_cellv(_pos + Vector2(-1,0)) != -1:
		count += 1
	return count
	
func _set_cell(tilemap, x, y, id):
	tilemap.set_cell(x, y, id, false, false, false, get_subtile_with_priority(id,tilemap))
	
	
func get_subtile_with_priority(id, tilemap: TileMap):
	var tiles = tilemap.tile_set
	var rect = tilemap.tile_set.tile_get_region(id)
	var size_x = rect.size.x / tiles.autotile_get_size(id).x
	var size_y = rect.size.y / tiles.autotile_get_size(id).y
	var tile_array = []
	for x in range(size_x):
		for y in range(size_y):
			var priority = tiles.autotile_get_subtile_priority(id, Vector2(x ,y))
			for p in priority:
				tile_array.append(Vector2(x,y))

	return tile_array[randi() % tile_array.size()]


func ChangeTile(data):
	if data["isWatered"]:
		watered.set_cellv(data["l"], 0)
		hoed.set_cellv(data["l"], 0)
	elif data["isHoed"] and not data["isWatered"]:
		hoed.set_cellv(data["l"], 0)
	else: 
		hoed.set_cellv(data["l"], -1)
		watered.set_cellv(data["l"], -1)
		validTiles.set_cellv(data["l"], 0)
	hoed.update_bitmask_region()
	watered.update_bitmask_region()
	
func PlaceSeedInWorld(id, item_name, location, days_to_grow):
	var plantedCrop = PlantedCrop.instance()
	plantedCrop.name = str(id)
	plantedCrop.initialize(item_name, location, days_to_grow, false, false)
	add_child(plantedCrop, true)
	plantedCrop.global_position = fence.map_to_world(location) + Vector2(0, 16)
			

func PlaceItemInWorld(id, item_name, location):
	print("PLACE ITEM IN WORLD " + item_name + str(location))
	match item_name:
		"torch":
			var torchObject = TorchObject.instance()
			torchObject.name = str(id)
			torchObject.initialize(location)
			add_child(torchObject,true)
			torchObject.position = validTiles.map_to_world(location) + Vector2(16, 22)
		"wood fence":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			call_deferred("add_child", tileObjectHurtBox,true)
			tileObjectHurtBox.global_position = fence.map_to_world(location) + Vector2(16, 16)
			fence.set_cellv(location, 0)
			fence.update_bitmask_region()
		"wood barrel":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence.map_to_world(location) + Vector2(16, 16)
			objects.set_cellv(location, 0)
		"wood box":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence.map_to_world(location) + Vector2(16, 16)
			objects.set_cellv(location, 1)
		"wood chest":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence.map_to_world(location) + Vector2(16, 16)
			objects.set_cellv(location, 2)
			validTiles.set_cellv(location + Vector2(1, 0), -1)
		"stone chest":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence.map_to_world(location) + Vector2(16, 16)
			objects.set_cellv(location, 5)
			validTiles.set_cellv(location + Vector2(1, 0), -1)
		"house":
			if location == Server.player_house_position:
				var playerHouse = PlayerHouse.instance()
				playerHouse.name = str(id)
				call_deferred("add_child", playerHouse, true)
				playerHouse.global_position = fence.map_to_world(location) + Vector2(6,6)
				set_player_house_invalid_tiles(location)
			else:
				var playerHouseTemplate = PlayerHouseTemplate.instance()
				playerHouseTemplate.name = str(id)
				call_deferred("add_child", playerHouseTemplate, true)
				playerHouseTemplate.global_position = fence.map_to_world(location) + Vector2(6,6)
				set_player_house_invalid_tiles(location)
		"wood path1":
			path.set_cellv(location, 0)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence.map_to_world(location) + Vector2(16, 16)
		"wood path2":
			path.set_cellv(location, 1)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence.map_to_world(location) + Vector2(16, 16)
		"stone path1":
			path.set_cellv(location, 2)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence.map_to_world(location) + Vector2(16, 16)
		"stone path2":
			path.set_cellv(location, 3)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence.map_to_world(location) + Vector2(16, 16)
		"stone path3":
			path.set_cellv(location, 4)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence.map_to_world(location) + Vector2(16, 16)
		"stone path4":
			path.set_cellv(location, 5)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence.map_to_world(location) + Vector2(16, 16)
	

func set_player_house_invalid_tiles(location):
	for x in range(8):
		for y in range(4):
			validTiles.set_cellv(location + Vector2(x, -y), -1)


func UpdateWorldState(world_state):					
	if world_state["t"] > last_world_state:
		var new_day = bool(world_state["day"])
		if day != new_day and Server.isLoaded:
			day = new_day
			PlayerInventory.day_num = int(world_state["day_num"])
			PlayerInventory.season = str(world_state["season"])
			if new_day == false:
				get_node("/root/World/Players/" + str(Server.player_id)).set_night()
			else: 
				get_node("/root/World/Players/" + str(Server.player_id)).set_day()
			
		last_world_state = world_state["t"]
		world_state_buffer.append(world_state)

func _physics_process(delta):
	#get_node("/root/World").PlaceItemInWorld(data["id"], data["n"], data["l"])
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
								get_node(str(item)).daysUntilHarvest = data["d"]
								get_node(str(item)).refresh_image()
							else:
								PlaceSeedInWorld(item, data["n"], data["l"], data["d"])
					"placable":
						for item in world_state_buffer[2]["decorations"][decoration].keys():
							if not has_node(str(item)):
								var data = world_state_buffer[2]["decorations"][decoration][item]
								PlaceItemInWorld(item, data["n"], data["l"])
			var interpolation_factor = float(render_time - world_state_buffer[1]["t"]) / float(world_state_buffer[2]["t"] - world_state_buffer[1]["t"])
			for player in world_state_buffer[2]["players"].keys():
				if str(player) == "t":
					continue
				if player == Server.player_id:
					continue
				if $Players.has_node(str(player)) and not player == Server.player_id:
					#print(player)
					#print(Server.player_id)
					
					if world_state_buffer[1]["players"].has(player):
						var new_position = lerp(world_state_buffer[1]["players"][player]["p"], world_state_buffer[2]["players"][player]["p"], interpolation_factor)
						$Players.get_node(str(player)).MovePlayer(new_position, world_state_buffer[1]["players"][player]["d"])
				else:
					if not mark_for_despawn.has(player):
						spawnNewPlayer(world_state_buffer[2]["players"][player])

		elif render_time > world_state_buffer[1].t:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["t"]) / float(world_state_buffer[1]["t"] - world_state_buffer[0]["t"]) - 1.00
			for player in world_state_buffer[1]["players"].keys():
				if $Players.has_node(str(player)) and not player == Server.player_id:
					#print("player is me" + player == Server.player_id)
					print(Server.player_id)
					var position_delta = (world_state_buffer[1]["players"][player]["p"] - world_state_buffer[0]["players"][player]["p"])
					var new_position = world_state_buffer[1]["players"][player]["p"] + (position_delta * extrapolation_factor)
					$Players.get_node(str(player)).MovePlayer(new_position, world_state_buffer[1]["players"][player]["d"])

