extends YSort

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

onready var hoed_grass_tiles = $GroundTiles/HoedAutoTiles
onready var watered_grass_tiles = $GroundTiles/WateredAutoTiles
onready var invalid_tiles_for_nature_placement = $GroundTiles/InvalidTileForNaturePlacement
onready var valid_tiles_for_object_placement = $GroundTiles/ValidTilesForObjectPlacement
onready var invisible_planted_crop_cells = $GroundTiles/InvisiblePlantedCropCells
onready var fence_tiles = $DecorationTiles/FenceAutoTile
onready var placable_object_tiles = $DecorationTiles/PlacableObjectTiles
onready var path_tiles = $DecorationTiles/PlacablePathTiles

onready var Player = $Player

var rng = RandomNumberGenerator.new()


onready var object_types = ["tree", "tree stump", "tree branch", "ore large", "ore small"]
onready var tall_grass_types = ["dark green", "green", "red", "yellow"]
onready var treeTypes = ['A','B', 'C', 'D', 'E']
onready var oreTypes = ["Stone", "Cobblestone"]
onready var randomBorderTiles = [Vector2(0, 1), Vector2(1, 1), Vector2(-1, 1), Vector2(0, -1), Vector2(-1, -1), Vector2(1, -1), Vector2(1, 0), Vector2(-1, 0)]

var object_name
var position_of_object
var object_variety

const NUM_FARM_OBJECTS = 550
const NUM_GRASS_BUNCHES = 150
const NUM_GRASS_TILES = 75
const NUM_FLOWER_TILES = 250
const MAX_GRASS_BUNCH_SIZE = 24

var Player_template = preload("res://World/Player/PlayerTemplate.tscn")

#func SpawnNewPlayer(player_id, spawn_position):
#	print('SPAWN PLAYER')
#	if get_tree().get_network_unique_id() == player_id:
#		pass
#	else:
#		if not has_node(str(player_id)):
#			var new_player = Player_template.instance()
#			new_player.getCharacterById(player_id)
#			new_player.position = spawn_position
#			new_player.name = str(player_id)
#			add_child(new_player)
#
#func DespawnPlayer(player_id):
#	if has_node(str(player_id)):
#		#yield(get_tree().create_timer(0.2), "timeout")
#		players.erase(player_id)
#		get_node(str(player_id)).queue_free()

const PlayerScene = preload("res://World/Player/Player.tscn")

func spawn_player():
	var player = Player.instance()
	player.initialize_camera_limits(Vector2(0, -64), Vector2(10000, 10000))
	add_child(player)
	player.position = Vector2(100, 100)


var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100
var decorations = []
var players = []
var world_state = {}

func UpdateWorldState(_world_state):
	world_state = _world_state
#	if decorations.empty():
#		for decoration in world_state.decoration_state.keys():
#			var treeObject = TreeObject.instance()
#			treeObject.name = decoration
#			treeObject.initialize(world_state.decoration_state[decoration]["v"], world_state.decoration_state[decoration]["p"], world_state.decoration_state[decoration]["g"])
#			add_child(treeObject)
#			treeObject.position = world_state.decoration_state[decoration]["p"]
#			decorations.append(decoration)
#	else:
#		for decoration in world_state.decoration_state.keys():
#			if not decorations.has(decoration):
#				var treeObject = TreeObject.instance()
#				treeObject.name = decoration
#				treeObject.initialize(world_state.decoration_state[decoration]["v"], world_state.decoration_state[decoration]["p"], world_state.decoration_state[decoration]["g"])
#				add_child(treeObject)
#				treeObject.position = world_state.decoration_state[decoration]["p"]
#				decorations.append(decoration)
#	if world_state["T"] > last_world_state:
#		last_world_state = world_state["T"]
#		var tempState = {}
#		tempState["players"] = world_state["players"]
#		tempState["T"] = world_state["T"]
#		world_state_buffer.append(tempState)

func _physics_process(delta):
	pass
#	if not world_state.empty():
#		if players.empty():
#			for player_id in world_state["players"]:
#				print("spawning player")
#				SpawnNewPlayer(player_id, Vector2(920,496))
#				players.append(player_id)
#		else:
#			for player_id in world_state["players"]:
#				if not players.has(player_id):
#					print("spawning player")
#					SpawnNewPlayer(player_id, Vector2(920,496))
#					players.append(player_id)
#	var render_time = Server.client_clock - interpolation_offset
#	if world_state_buffer.size() > 1:
#		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T:
#			world_state_buffer.remove(0)
#		if world_state_buffer.size() > 2:
#			for player in world_state_buffer[2]["player_state"].keys():
#				if str(player) == "T":
#					continue
#				if str(player) == str(get_tree().get_network_unique_id()):
#					continue
#				if not world_state_buffer[1]["player_state"].has(player):
#					continue
#				if has_node(str(player)):
#					pass
#				else:
#					print("spawning player")
#					SpawnNewPlayer(player, world_state_buffer[2]["player_state"][player]["P"])

#func _physics_process(delta):
#	var render_time = Server.client_clock - interpolation_offset
#	if world_state_buffer.size() > 1:
#		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T:
#			world_state_buffer.remove(0)
#		if world_state_buffer.size() > 2:
#			var interpolation_factor = float(render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
#			for player in world_state_buffer[2]["player_state"].keys():
#				if str(player) == "T":
#					continue
#				if str(player) == str(get_tree().get_network_unique_id()):
#					continue
#				if not world_state_buffer[1]["player_state"].has(player):
#					continue
#				if has_node(str(player)):
#					var new_position = lerp(world_state_buffer[1]["player_state"][player]["P"], world_state_buffer[2]["player_state"][player]["P"], interpolation_factor)
#					get_node(str(player)).MovePlayer(new_position, world_state_buffer[1]["player_state"][player]["D"])
#				else:
#					print("spawning player")
#					SpawnNewPlayer(player, world_state_buffer[2]["player_state"][player]["P"])
#
#		elif render_time > world_state_buffer[1].T:
#			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
#			for player in world_state_buffer[1]["player_state"].keys():
#				if str(player) == "T":
#					continue
#				if player == get_tree().get_network_unique_id():
#					continue
#				if not world_state_buffer[0]["player_state"].has(player):
#					continue
#				if has_node(str(player)):
#					var position_delta = (world_state_buffer[1]["player_state"][player]["P"] - world_state_buffer[0]["player_state"][player]["P"])
#					var new_position = world_state_buffer[1]["player_state"][player]["P"] + (position_delta * extrapolation_factor)
#					get_node(str(player)).MovePlayer(new_position, world_state_buffer[1]["player_state"][player]["D"])


func _ready():

	pass
	
#	if PlayerFarmApi.player_farm_objects.size() == 0:
#		generate_farm()
#		generate_grass_bunches()
#		generate_grass_tiles()
#		generate_flower_tiles()
#	else:
#		load_farm()
#	load_player_crops()
#	load_player_placables()
#	DayNightTimer.connect("advance_day", self, "advance_crop_day")



var distance_to_waterfall_interval = 0
func _process(delta) -> void:
	$WaterTiles/WaterfallSound.volume_db = -6 * distance_to_waterfall_interval
	distance_to_waterfall_interval = 0 #(Player.get_position().distance_to($WaterTiles/SmokeEffect.get_position()) / 200)

func load_player_placables():
	for i in range(PlayerFarmApi.player_placable_objects.size()):
		place_object(PlayerFarmApi.player_placable_objects[i][0], null, PlayerFarmApi.player_placable_objects[i][1], null)
	for i in range(PlayerFarmApi.player_placable_paths.size()):
		place_object(PlayerFarmApi.player_placable_paths[i][0], PlayerFarmApi.player_placable_paths[i][1], PlayerFarmApi.player_placable_paths[i][2], null )

func load_farm():
	for i in range( PlayerFarmApi.player_farm_objects.size()):
		validate_location_and_remove_tiles(PlayerFarmApi.player_farm_objects[i][0], PlayerFarmApi.player_farm_objects[i][2])
		place_object(PlayerFarmApi.player_farm_objects[i][0], PlayerFarmApi.player_farm_objects[i][1], PlayerFarmApi.player_farm_objects[i][2], PlayerFarmApi.player_farm_objects[i][3])


func load_player_crops():
	for i in range(PlayerFarmApi.planted_crops.size()):
		invisible_planted_crop_cells.set_cellv(PlayerFarmApi.planted_crops[i][1], 0)
		hoed_grass_tiles.set_cellv(PlayerFarmApi.planted_crops[i][1], 0)
		valid_tiles_for_object_placement.set_cellv(PlayerFarmApi.planted_crops[i][1], -1)
		var plantedCrop = PlantedCrop.instance()
		plantedCrop.initialize(PlayerFarmApi.planted_crops[i][0], PlayerFarmApi.planted_crops[i][1], PlayerFarmApi.planted_crops[i][3], PlayerFarmApi.planted_crops[i][4],  PlayerFarmApi.planted_crops[i][5])
		add_child(plantedCrop)
		plantedCrop.global_position = valid_tiles_for_object_placement.map_to_world(PlayerFarmApi.planted_crops[i][1]) + Vector2(0, 16)
		if PlayerFarmApi.planted_crops[i][2]:
			watered_grass_tiles.set_cellv(PlayerFarmApi.planted_crops[i][1], 0)
	hoed_grass_tiles.update_bitmask_region()
	watered_grass_tiles.update_bitmask_region()

func generate_farm():
	for i in range(NUM_FARM_OBJECTS):
		rng.randomize()
		object_types.shuffle()
		object_name = object_types[0]
		object_variety = set_object_variety(object_name)
		find_random_location_and_place_object(object_name, object_variety, i)


func find_random_location_and_place_object(name, variety, i):
	rng.randomize()
	var location = Vector2(rng.randi_range(-50, 60), rng.randi_range(8, 82))
	if validate_location_and_remove_tiles(name, location):
		place_object(name, variety, location, true)
		PlayerFarmApi.player_farm_objects.append([name, variety, location, true])
	else:
		find_random_location_and_place_object(name, variety, i)

func generate_flower_tiles():
	for _i in range(NUM_FLOWER_TILES):
		rng.randomize()
		var location = Vector2(rng.randi_range(-50, 60), rng.randi_range(8, 82))
		if validate_location_and_remove_tiles("flower", location):
			var flowerObject = FlowerObject.instance()
			call_deferred("add_child", flowerObject)
			flowerObject.position = valid_tiles_for_object_placement.map_to_world(location) + Vector2(16, 32)
			PlayerFarmApi.player_farm_objects.append(["flower", null, location, null])


func generate_grass_bunches():
	for _i in range(NUM_GRASS_BUNCHES):
		var location = Vector2(rng.randi_range(-50, 60), rng.randi_range(8, 82))
		if validate_location_and_remove_tiles("tall grass", location):
			var tallGrassObject = TallGrassObject.instance()
			tall_grass_types.shuffle()
			tallGrassObject.initialize(tall_grass_types[0])
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position = valid_tiles_for_object_placement.map_to_world(location) + Vector2(16,32)
			PlayerFarmApi.player_farm_objects.append(["tall grass", tall_grass_types[0], location, null])
			create_grass_bunch(location, tall_grass_types[0])

func create_grass_bunch(loc, variety):
	rng.randomize()
	var randomNum = rng.randi_range(1, MAX_GRASS_BUNCH_SIZE)
	for _i in range(randomNum):
		randomBorderTiles.shuffle()
		loc += randomBorderTiles[0]
		if validate_location_and_remove_tiles("tall grass", loc):
			var tallGrassObject = TallGrassObject.instance()
			tallGrassObject.initialize(variety)
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position =  valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16,32)
			PlayerFarmApi.player_farm_objects.append(["tall grass", tall_grass_types[0], loc, null])
		else:
			loc -= randomBorderTiles[0]


func generate_grass_tiles():
	for _i in range(NUM_GRASS_TILES):
		rng.randomize()
		var location = Vector2(rng.randi_range(-50, 60), rng.randi_range(8, 82))
		if validate_location_and_remove_tiles("tall grass", location):
			var tallGrassObject = TallGrassObject.instance()
			tall_grass_types.shuffle()
			tallGrassObject.initialize(tall_grass_types[0])
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position =  valid_tiles_for_object_placement.map_to_world(location) + Vector2(16,32)
			PlayerFarmApi.player_farm_objects.append(["tall grass", tall_grass_types[0], location, null])

func set_object_variety(name):
	rng.randomize()
	if name == "tree" or name == "tree stump":
		treeTypes.shuffle()
		return treeTypes[0]
	elif name == "tree branch":
		return rng.randi_range(0, 11)
	else:
		oreTypes.shuffle()
		return oreTypes[0]


func validate_location_and_remove_tiles(item_name, loc):
	if item_name == "tree branch" or item_name == "ore small" or item_name == "tall grass" or item_name == "flower":
		if valid_tiles_for_object_placement.get_cellv(loc) != -1 and invalid_tiles_for_nature_placement.get_cellv(loc) != 0:
			valid_tiles_for_object_placement.set_cellv(loc, -1)
			return true
		else:
			return false
	else:
		if valid_tiles_for_object_placement.get_cellv(loc) != -1 \
		and valid_tiles_for_object_placement.get_cellv(loc + Vector2(0,1)) != -1 \
		and valid_tiles_for_object_placement.get_cellv(loc + Vector2(-1,1)) != -1 \
		and valid_tiles_for_object_placement.get_cellv(loc + Vector2(-1,0)) != -1 \
		and invalid_tiles_for_nature_placement.get_cellv(loc) == -1 \
		and invalid_tiles_for_nature_placement.get_cellv(loc + Vector2(0,1)) == -1 \
		and invalid_tiles_for_nature_placement.get_cellv(loc + Vector2(-1,1)) == -1 \
		and invalid_tiles_for_nature_placement.get_cellv(loc + Vector2(-1,0)) == -1:
				valid_tiles_for_object_placement.set_cellv(loc, -1)
				valid_tiles_for_object_placement.set_cellv(loc + Vector2(0, 1), -1)
				valid_tiles_for_object_placement.set_cellv(loc + Vector2(-1, 1), -1)
				valid_tiles_for_object_placement.set_cellv(loc + Vector2(-1, 0), -1)
				return true
		else:
			return false


func place_object(item_name, variety, loc, isFullGrowth):
	if item_name == "tree":
		var treeObject = TreeObject.instance()
		treeObject.initialize(variety, loc, isFullGrowth)
		call_deferred("add_child", treeObject)
		treeObject.position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(0, 24)
	elif item_name == "tree stump":
		var stumpObject = StumpObject.instance()
		stumpObject.initialize(variety, loc)
		call_deferred("add_child", stumpObject)
		stumpObject.position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(4, 36)
	elif item_name == "tree branch":
		var branchObject = BranchObject.instance()
		branchObject.initialize(variety, loc)
		call_deferred("add_child", branchObject)
		branchObject.position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(17, 16)
	elif item_name == "ore large":
		var oreObject = OreObject.instance()
		oreObject.initialize(variety, loc, isFullGrowth)
		call_deferred("add_child", oreObject)
		oreObject.position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(0, 28)
	elif item_name == "ore small":
		var smallOreObject = SmallOreObject.instance()
		smallOreObject.initialize(variety, loc)
		call_deferred("add_child", smallOreObject)
		smallOreObject.position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 24)
	elif item_name == "tall grass":
		var tallGrassObject = TallGrassObject.instance()
		tallGrassObject.initialize(variety)
		call_deferred("add_child", tallGrassObject)
		tallGrassObject.position =  valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16,32)
	elif item_name == "flower":
		var flowerObject = FlowerObject.instance()
		call_deferred("add_child", flowerObject)
		flowerObject.position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 32)
	elif item_name == "torch":
		valid_tiles_for_object_placement.set_cellv(loc, -1)
		var torchObject = TorchObject.instance()
		torchObject.initialize(loc)
		call_deferred("add_child", torchObject)
		torchObject.global_position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 22)
	elif item_name == "wood fence":
		fence_tiles.set_cellv(loc, 0)
		valid_tiles_for_object_placement.set_cellv(loc, -1)
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(item_name, loc)
		call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 16)
	elif item_name == "wood barrel":
		placable_object_tiles.set_cellv(loc, 0)
		valid_tiles_for_object_placement.set_cellv(loc, -1)
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(item_name, loc)
		call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 16)
	elif item_name == "wood box":
		placable_object_tiles.set_cellv(loc, 1)
		valid_tiles_for_object_placement.set_cellv(loc, -1)
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(item_name, loc)
		call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 16)
	elif item_name == "large wood chest":
		placable_object_tiles.set_cellv(loc, 2)
		valid_tiles_for_object_placement.set_cellv(loc, -1)
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(item_name, loc)
		call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 16)
	elif item_name == "wood path":
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(item_name, loc)
		call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 16)
		path_tiles.set_cellv(loc, variety - 1)
	elif item_name == "stone path":
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(item_name, loc)
		call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 16)
		path_tiles.set_cellv(loc, variety + 1)
	fence_tiles.update_bitmask_region()

func advance_crop_day():
	PlayerFarmApi.advance_day()
	get_tree().call_group("active_crops", "delete_crop")
	watered_grass_tiles.clear()
	load_player_crops()


func _on_EnterCaveArea_area_entered(area):
	SceneChanger.change_scene("res://World/Cave/Cave.tscn")
