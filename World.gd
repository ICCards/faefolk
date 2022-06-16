extends Node2D


onready var sand = $SandTiles
onready var grass = $GreenGrassTiles
onready var darkGrass = $DarkGreenGrassTiles
onready var water = $WaterTileMap



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
const _character = preload("res://Global/Data/Characters.gd")

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100
var decorations = []
var mark_for_despawn = []
	
func spawnPlayer(value):
	print('gettiing player')
	if not value.empty():
		print("My Character")
		print(value["c"])
		var player = Player.instance()
		#player.initialize_camera_limits(Vector2(0, 0), Vector2(1920, 1080))
		player.position = value["p"]
		print(str(value["p"]))
		player.name = str(value["id"])
		player.character = _character.new()
		player.character.LoadPlayerCharacter(value["c"]) 
		add_child(player)
		
		
func spawnNewPlayer(player):
	if not player.empty():
		if not has_node(str(player["id"])):
			print("spawning")
			var new_player = Player_template.instance()
			new_player.position = player["p"]
			new_player.name = str(player["id"])
			new_player.character = _character.new()
			new_player.character.LoadPlayerCharacter(player["c"]) 
			add_child(new_player)
	
	
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
	print("building map")
#	for x in range(1920):
#		for y in range(1080):
#			grass.set_cell(x, y, 0)
	
	for position in map["dirt"]:
		set_cell(sand, position.x, position.y, 0)
	for position in map["dark_grass"]:
		set_cell(sand, position.x, position.y, 0)
		grass.set_cellv(position, 0)
	for position in map["grass"]:
		grass.set_cellv(position, 0)
		darkGrass.set_cellv(position, 0)
	for position in map["water"]:
		darkGrass.set_cellv(position, 0)
		water.set_cellv(position, 0)
	
	grass.update_bitmask_region()
	darkGrass.update_bitmask_region()
	water.update_bitmask_region()
		
func set_cell(tilemap, x, y, id):
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


func UpdateWorldState(world_state):					
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
	if world_state["t"] > last_world_state:
		last_world_state = world_state["t"]
		world_state_buffer.append(world_state)

func _physics_process(delta):
	var render_time = Server.client_clock - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].t:
			world_state_buffer.remove(0)
		if world_state_buffer.size() > 2:
			var interpolation_factor = float(render_time - world_state_buffer[1]["t"]) / float(world_state_buffer[2]["t"] - world_state_buffer[1]["t"])
			for player in world_state_buffer[2]["players"].keys():
				if str(player) == "t":
					continue
				if player == get_tree().get_network_unique_id():
					if not has_node(str(player)):
						spawnPlayer(world_state_buffer[2]["players"][player])
				if not world_state_buffer[1]["players"].keys().has(player):
					continue
				if has_node(str(player)) and not player == get_tree().get_network_unique_id():
					var new_position = lerp(world_state_buffer[1]["players"][player]["p"], world_state_buffer[2]["players"][player]["p"], interpolation_factor)
					get_node(str(player)).MovePlayer(new_position, world_state_buffer[1]["players"][player]["d"])
				else:
					if not mark_for_despawn.has(player):
						spawnNewPlayer(world_state_buffer[2]["players"][player])

		elif render_time > world_state_buffer[1].t:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["t"]) / float(world_state_buffer[1]["t"] - world_state_buffer[0]["t"]) - 1.00
			for player in world_state_buffer[1]["players"].keys():
				if str(player) == "t":
					continue
				if player == get_tree().get_network_unique_id():
					continue
				if not world_state_buffer[0]["players"].keys().has(player):
					continue
				if has_node(str(player)) and not player == get_tree().get_network_unique_id():
					var position_delta = (world_state_buffer[1]["players"][player]["p"] - world_state_buffer[0]["players"][player]["p"])
					var new_position = world_state_buffer[1]["players"][player]["p"] + (position_delta * extrapolation_factor)
					get_node(str(player)).MovePlayer(new_position, world_state_buffer[1]["players"][player]["d"])

