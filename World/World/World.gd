extends YSort

onready var sand = $GeneratedTiles/SandTiles
onready var grass = $GeneratedTiles/GreenGrassTiles
onready var darkGrass = $GeneratedTiles/DarkGreenGrassTiles
onready var water = $GeneratedTiles/Water
onready var border = $GeneratedTiles/BorderTiles
onready var validTiles = $GeneratedTiles/ValidTiles
onready var hoed = $FarmingTiles/HoedAutoTiles
onready var watered = $FarmingTiles/WateredAutoTiles

onready var Player = preload("res://World/Player/Player/Player.tscn")
onready var Player_template = preload("res://World/Player/PlayerTemplate/PlayerTemplate.tscn")
onready var Player_pet = preload("res://World/Player/Pet/PlayerPet.tscn")

onready var TreeObject = preload("res://World/Objects/Nature/Trees/TreeObject.tscn")
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

func _ready():
	var loadingScreen = LoadingScreen.instance()
	loadingScreen.name = "loadingScreen"
	add_child(loadingScreen)
	get_node("loadingScreen").set_phase("Getting map")
	yield(get_tree().create_timer(1), "timeout")
	Server.generated_map.clear()
	Server.generate_map()
	wait_for_map()
	Sounds.connect("volume_change", self, "change_ambient_volume")
	Server.world = self
	
func change_ambient_volume():
	$AmbientSound.volume_db = Sounds.return_adjusted_sound_db("ambient", -14)

func wait_for_map():
	if not Server.generated_map.empty():
		buildMap(Server.generated_map)
	else:
		yield(get_tree().create_timer(0.5), "timeout")
		wait_for_map()

func spawnPlayer(value):
	print('gettiing player')
	print(value)
	if not value.empty():
		print("My Character")
		print(value["c"])
		var player = Player.instance()
		#player.initialize_camera_limits(Vector2(0, 0), Vector2(1920, 1080))
		print(str(value["p"]))
		player.initialize_camera_limits(Vector2(-64,-160), Vector2(9664, 9664))
		player.name = str(value["id"])
		player.principal = value["principal"]
		player.character = _character.new()
		player.character.LoadPlayerCharacter(value["c"])
		$Players.add_child(player)
		if Server.player_house_position == null:
			player.position = sand.map_to_world(Util.string_to_vector2(value["p"])) 
		else: 
			player.position = sand.map_to_world(Server.player_house_position) + Vector2(135, 60)
		print('getting map')
		
func spawnPlayerExample():
	var player = Player.instance()
	player.initialize_camera_limits(Vector2(-64,-160), Vector2(9664, 9664))
	player.name = Server.player_id
	player.character = _character.new()
	player.character.LoadPlayerCharacter("human_male") 
	$Players.add_child(player)
	if Server.player_house_position == null:
		player.position = sand.map_to_world(Vector2(4,4)) 
	else: 
		player.position = sand.map_to_world(Server.player_house_position) + Vector2(135, 60)
#	var player_pet = Player_pet.instance()
#	add_child(player_pet)
#	player_pet.position = sand.map_to_world(Vector2(8,8)) 
	
	print('getting map')
		
		
func spawnNewPlayer(player):
	if not player.empty():
		if not has_node(str(player["id"])):
			print("spawning new player")
			print(player["p"])
			var new_player = Player_template.instance()
			new_player.position = sand.map_to_world(Util.string_to_vector2(player["p"]))
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
	get_node("loadingScreen").set_phase("Building dirt")
	for id in map["dirt"]:
		var loc = Util.string_to_vector2(map["dirt"][id]["l"])
		var x = loc.x
		var y = loc.y
		tile_ids["" + str(x) + "" + str(y)] = id
		if map["dirt"][id]["isWatered"]:
			watered.set_cellv(loc, 0)
			hoed.set_cellv(loc, 0)
		if map["dirt"][id]["isHoed"]:
			hoed.set_cellv(loc, 0)
		if Util.chance(5):
			Tiles._set_cell( sand, loc.x, loc.y, 1 )
		else:
			Tiles._set_cell( sand, loc.x, loc.y, 0 )
	hoed.update_bitmask_region()
	watered.update_bitmask_region()
	print("LOADED DIRT")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["dark_grass"]:
		var loc = Util.string_to_vector2(map["dark_grass"][id])
		Tiles._set_cell(sand, loc.x, loc.y, 0)
		grass.set_cellv(loc, 0)
	print("LOADED GRASS")
	get_node("loadingScreen").set_phase("Building grass")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["grass"]:
		var loc = Util.string_to_vector2(map["grass"][id])
		grass.set_cellv(loc, 0)
		darkGrass.set_cellv(loc, 0)
	print("LOADED DG")
	get_node("loadingScreen").set_phase("Building water")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["water"]:
		var loc = Util.string_to_vector2(map["water"][id])
		validTiles.set_cellv(loc, -1)
		darkGrass.set_cellv(loc, 0)
		water.set_cellv(loc, 0)
	print("LOADED WATER")
	get_node("loadingScreen").set_phase("Building trees")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["tree"]:
		var loc = Util.string_to_vector2(map["tree"][id]["l"])
		if is_valid_position(loc, "tree"):
			treeTypes.shuffle()
			var variety = treeTypes.front()
			var object = TreeObject.instance()
			object.health = map["tree"][id]["h"]
			object.initialize(variety, loc)
			object.position = sand.map_to_world(loc) + Vector2(0, -8)
			object.name = id
			add_child(object,true)
	print("LOADED TREES")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["log"]:
		var loc = Util.string_to_vector2(map["log"][id]["l"])
		if is_valid_position(loc, "log"):
			validTiles.set_cellv(loc, -1)
			rng.randomize()
			var variety = rng.randi_range(0, 11)
			var object = BranchObject.instance()
			object.name = id
			object.health = map["log"][id]["h"]
			object.initialize(variety,loc)
			object.position = sand.map_to_world(loc) + Vector2(16, 16)
			add_child(object,true)
	print("LOADED LOGS")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["stump"]:
		var loc = Util.string_to_vector2(map["stump"][id]["l"])
		if is_valid_position(loc, "stump"):
			treeTypes.shuffle()
			var variety = treeTypes.front()
			var object = StumpObject.instance()
			object.health = map["stump"][id]["h"]
			object.name = id
			object.initialize(variety,loc)
			object.position = sand.map_to_world(loc) + Vector2(4,0)
			add_child(object,true)
	print("LOADED STUMPS")
	get_node("loadingScreen").set_phase("Building ore")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["ore_large"]:
		var loc = Util.string_to_vector2(map["ore_large"][id]["l"])
		if is_valid_position(loc, "ore_large"):
			oreTypes.shuffle()
			var variety = oreTypes.front()
			var object = OreObject.instance()
			object.health = map["ore_large"][id]["h"]
			object.name = id
			object.initialize(variety,loc)
			object.position = sand.map_to_world(loc) 
			add_child(object,true)
	print("LOADED LARGE OrE")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["ore"]:
		var loc = Util.string_to_vector2(map["ore"][id]["l"])
		if is_valid_position(loc, "ore"):
			oreTypes.shuffle()
			var variety = oreTypes.front()
			var object = SmallOreObject.instance()
			object.health = map["ore"][id]["h"]
			object.name = id
			object.initialize(variety,loc)
			object.position = sand.map_to_world(loc) + Vector2(16, 24)
			add_child(object,true)
	print("LOADED OrE")
	get_node("loadingScreen").set_phase("Building tall grass")
	yield(get_tree().create_timer(0.5), "timeout")
	var count = 0
	for id in map["tall_grass"]:
		var loc = Util.string_to_vector2(map["tall_grass"][id]["l"])
		if is_valid_position(loc, "tall_grass"):
			count += 1
			tall_grass_types.shuffle()
			var variety = tall_grass_types.front()
			var object = TallGrassObject.instance()
			object.name = id
			object.initialize(variety)
			object.position = sand.map_to_world(loc) + Vector2(16, 32)
			add_child(object,true)
		if count == 130:
			yield(get_tree().create_timer(0.2), "timeout")
			count = 0
	print("LOADED TALL GRASS")
	get_node("loadingScreen").set_phase("Building flowers")
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["flower"]:
		var loc = Util.string_to_vector2(map["flower"][id]["l"])
		if is_valid_position(loc, "flower"):
			var object = FlowerObject.instance()
			object.position = sand.map_to_world(loc) + Vector2(16, 32)
			add_child(object,true)
	print("LOADED FLOWERS")
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("loadingScreen").set_phase("Generating world")
	check_and_remove_invalid_autotiles(map)
	generate_border_tiles()
	yield(get_tree().create_timer(0.5), "timeout")
	border.update_bitmask_region()
	get_node("loadingScreen").set_phase("Spawning in")
	yield(get_tree().create_timer(1.0), "timeout")
	Server.player_state = "WORLD"
	Server.isLoaded = true
	print("Map loaded")
	$AmbientSound.volume_db = Sounds.return_adjusted_sound_db("ambient", -14)
	$AmbientSound.play()
	Server.world = self
	yield(get_tree().create_timer(8.5), "timeout")
	get_node("loadingScreen").queue_free()
	spawnPlayer(Server.player)
	#spawnPlayerExample()
	
func check_and_remove_invalid_autotiles(map):
	for i in range(6):
		for id in map["grass"]: 
			var loc = Util.string_to_vector2(map["grass"][id])
			if Tiles.return_neighboring_cells(loc, darkGrass) <= 1:
				darkGrass.set_cellv(loc, -1)
		yield(get_tree().create_timer(0.25), "timeout")
		for id in map["dark_grass"]: 
			var loc = Util.string_to_vector2(map["dark_grass"][id])
			if Tiles.return_neighboring_cells(loc, grass) <= 1:
				grass.set_cellv(loc, -1)
		yield(get_tree().create_timer(0.25), "timeout")
		for id in map["water"]:
			var loc = Util.string_to_vector2(map["water"][id])
			if Tiles.return_neighboring_cells(loc, water) <= 1:
				water.set_cellv(loc, -1)
		yield(get_tree().create_timer(0.25), "timeout")
	water.update_bitmask_region()
	grass.update_bitmask_region()
	darkGrass.update_bitmask_region()



func build_valid_tiles():
	for x in range(298):
		for y in range(298):
			validTiles.set_cellv(Vector2(x+1, y+1), 0)
	
func is_valid_position(_pos, _name):
	if _pos.x > 1 and _pos.x < 299 and _pos.y > 1 and _pos.y < 299:
		if validTiles.get_cellv(_pos) != -1 and _name != "tree" and _name != "stump":
			validTiles.set_cellv(_pos, -1)
			return true
		elif (_name == "tree" or _name == "stump" or name == "ore_large") and \
				validTiles.get_cellv(_pos) != -1 and \
				validTiles.get_cellv(_pos + Vector2(-1, -1)) != -1 and \
				validTiles.get_cellv(_pos + Vector2(-1, 0)) != -1 and \
				validTiles.get_cellv(_pos + Vector2(0, -1)) != -1:
					validTiles.set_cellv(_pos, -1)
					validTiles.set_cellv(_pos + Vector2(-1, -1), -1 )
					validTiles.set_cellv(_pos + Vector2(-1, 0), -1 )
					validTiles.set_cellv(_pos + Vector2(0, -1), -1)
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
		Tiles._set_cell(border, i-2, -4, 4)
		Tiles._set_cell(border, i-2, -5, 4)
		Tiles._set_cell(border, i-2, 300, 4)
		Tiles._set_cell(border, i-2, 301, 4)
		Tiles._set_cell(border, -1, i-3, 4)
		Tiles._set_cell(border, -2, i-3, 4)
		Tiles._set_cell(border, 300, i-3, 4)
		Tiles._set_cell(border, 301, i-3, 4)
		
	
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
			get_node("/root/World/Players/" + Server.player_id + "/Camera2D/UserInterface/CurrentTime").update_time(int(world_state["time_elapsed"]))
		if Server.day != new_day and Server.isLoaded:
			Server.day = new_day
			if new_day == false:
				if has_node("Players/" + Server.player_id):
					get_node("/root/World/Players/" + Server.player_id).set_night()
			else:
				if has_node("Players/" + Server.player_id):
					watered.clear()
					get_node("/root/World/Players/" + Server.player_id).set_day()
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

