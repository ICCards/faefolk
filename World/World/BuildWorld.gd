extends Node

onready var dirt = get_node("../GeneratedTiles/DirtTiles")
onready var plains = get_node("../GeneratedTiles/GreenGrassTiles")
onready var forest = get_node("../GeneratedTiles/DarkGreenGrassTiles")
#onready var water = $GeneratedTiles/Water
onready var validTiles = get_node("../ValidTiles") 
onready var navTiles = get_node("../Navigation2D/NavTiles")
onready var hoed = get_node("../FarmingTiles/HoedAutoTiles")
onready var watered = get_node("../FarmingTiles/WateredAutoTiles")
onready var snow = get_node("../GeneratedTiles/SnowTiles")
onready var waves = get_node("../GeneratedTiles/WaveTiles")
onready var wetSand = get_node("../GeneratedTiles/WetSandBeachBorder")
onready var sand = get_node("../GeneratedTiles/DrySandTiles")
onready var shallow_ocean = get_node("../GeneratedTiles/ShallowOcean")
onready var deep_ocean = get_node("../GeneratedTiles/DeepOcean")
onready var top_ocean = get_node("../GeneratedTiles/TopOcean")

onready var Player = load("res://World/Player/Player/Player.tscn")
onready var _character = load("res://Global/Data/Characters.gd")

var built_chunks = []
var current_chunks = []

func _ready():
	spawn_player()

func spawn_player():
	var player = Player.instance()
	player.is_building_world = true
	#player.name = str(get_tree().get_network_unique_id())
	player.name = str("PLAYER")
	player.character = _character.new()
	player.character.LoadPlayerCharacter("human_male")
	get_node("../Players").add_child(player)
	player.spawn_position = Vector2(500*32,500*32)
	if not BuildCaveLevel.is_player_going_down:
		player.position = Util.string_to_vector2(MapData.world["cave_entrance_location"])*32 + Vector2(32,0)
	else:
		player.position = Vector2(500*32,500*32)

func _on_BuildTerrain_timeout():
	build_terrain()

func build_terrain():
	if Server.player_node:
		var loc = Server.player_node.position / 32
		var columns
		var rows
		var new_chunks = []
		var chunks_to_remove = []
		if loc.x < 218.75:
			columns = [1,2]
		elif loc.x < 281.25:
			columns = [2,3]
		elif loc.x < 343.75:
			columns = [3,4]
		elif loc.x < 406.25:
			columns = [4,5]
		elif loc.x < 468.75:
			columns = [5,6]
		elif loc.x < 531.25:
			columns = [6,7]
		elif loc.x < 593.75:
			columns = [7,8]
		elif loc.x < 656.25:
			columns = [8,9]
		elif loc.x < 718.75:
			columns = [9,10]
		elif loc.x < 781.25:
			columns = [10,11]
		else:
			columns = [11, 12]

		if loc.y < 218.75:
			rows = ["A","B"]
		elif loc.y < 281.25:
			rows = ["B","C"]
		elif loc.y < 343.75:
			rows = ["C","D"]
		elif loc.y < 406.25:
			rows = ["D","E"]
		elif loc.y < 468.75:
			rows = ["E","F"]
		elif loc.y < 531.25:
			rows = ["F","G"]
		elif loc.y < 593.75:
			rows = ["G","H"]
		elif loc.y < 656.25:
			rows = ["H","I"]
		elif loc.y < 718.75:
			rows = ["I","J"]
		elif loc.y < 781.25:
			rows = ["J","K"]
		else:
			rows = ["K","L"]
		for column in columns:
			for row in rows:
				new_chunks.append(row+str(column))
		if current_chunks == new_chunks:
			return
		current_chunks = new_chunks
		for new_chunk in new_chunks:
			if not built_chunks.has(new_chunk):
				built_chunks.append(new_chunk)
				print("SPAWN CHUNK " + new_chunk)
				spawn_chunk(new_chunk)

func spawn_chunk(chunk_name):
	var _chunk = MapData.return_chunk(chunk_name[0],chunk_name.substr(1,-1))
	for id in _chunk["plains"]:
		var loc = Util.string_to_vector2(_chunk["plains"][id])
		plains.set_cellv(loc, 0)
	yield(get_tree(), "idle_frame")
	for id in _chunk["snow"]:
		var loc = Util.string_to_vector2(_chunk["snow"][id])
		snow.set_cellv(loc, 0)
	yield(get_tree(), "idle_frame")
	for id in _chunk["forest"]:
		var loc = Util.string_to_vector2(_chunk["forest"][id])
		forest.set_cellv(loc, 0)
	yield(get_tree(), "idle_frame")
	for id in _chunk["beach"]:
		var loc = Util.string_to_vector2(_chunk["beach"][id])
		Tiles._set_cell(sand, loc.x, loc.y, 0)
	yield(get_tree(), "idle_frame")
	for id in _chunk["desert"]:
		var loc = Util.string_to_vector2(_chunk["desert"][id])
		Tiles._set_cell(sand, loc.x, loc.y, 0)
	yield(get_tree(), "idle_frame")
	for id in _chunk["dirt"]:
		var loc = Util.string_to_vector2(_chunk["dirt"][id])
		dirt.set_cellv(loc, 0)
	yield(get_tree(), "idle_frame")
	for id in _chunk["ocean"]:
		var loc = Util.string_to_vector2(_chunk["ocean"][id])
		if sand.get_cellv(loc) == -1:
			wetSand.set_cellv(loc, 0)
			waves.set_cellv(loc, 5)
			shallow_ocean.set_cellv(loc,0)
			top_ocean.set_cellv(loc,0)
			deep_ocean.set_cellv(loc,0)
			validTiles.set_cellv(loc,-1)
	for id in _chunk["beach"]:
		var loc = Util.string_to_vector2(_chunk["beach"][id])
		#Tiles._set_cell(sand, loc.x, loc.y, 0)
		for i in range(4):
			if sand.get_cellv(loc+Vector2(i,0)) != -1 or sand.get_cellv(loc+Vector2(-i,0)) != -1 or sand.get_cellv(loc+Vector2(0,i)) != -1 or sand.get_cellv(loc+Vector2(0,-i)) != -1:
				shallow_ocean.set_cellv(loc+Vector2(i,0),-1)
				top_ocean.set_cellv(loc+Vector2(i,0),-1)
				deep_ocean.set_cellv(loc+Vector2(i,0),-1)
				waves.set_cellv(loc+Vector2(i,0), -1)
				shallow_ocean.set_cellv(loc+Vector2(-i,0),-1)
				top_ocean.set_cellv(loc+Vector2(-i,0),-1)
				deep_ocean.set_cellv(loc+Vector2(-i,0),-1)
				waves.set_cellv(loc+Vector2(-i,0), -1)
				shallow_ocean.set_cellv(loc+Vector2(0,i),-1)
				top_ocean.set_cellv(loc+Vector2(0,i),-1)
				deep_ocean.set_cellv(loc+Vector2(0,i),-1)
				waves.set_cellv(loc+Vector2(0,i), -1)
				shallow_ocean.set_cellv(loc+Vector2(0,-i),-1)
				top_ocean.set_cellv(loc+Vector2(0,-i),-1)
				deep_ocean.set_cellv(loc+Vector2(0,-i),-1)
				waves.set_cellv(loc+Vector2(0,-i), -1)
		yield(get_tree(), "idle_frame")
		for i in range(4):
			i += 4
			if sand.get_cellv(loc+Vector2(i,0)) != -1 or sand.get_cellv(loc+Vector2(-i,0)) != -1 or sand.get_cellv(loc+Vector2(0,i)) != -1 or sand.get_cellv(loc+Vector2(0,-i)) != -1:
				deep_ocean.set_cellv(loc+Vector2(i,0),-1)
				deep_ocean.set_cellv(loc+Vector2(-i,0),-1)
				deep_ocean.set_cellv(loc+Vector2(0,i),-1)
				deep_ocean.set_cellv(loc+Vector2(0,-i),-1)
		yield(get_tree(), "idle_frame")
	update_bitmasks(chunk_name)
	yield(get_tree(), "idle_frame")

func update_bitmasks(chunk_name):
	var row = chunk_name[0]
	var column = int(chunk_name.substr(1, -1))
	var start_x
	var start_y
	var end_x
	var end_y
	match column:
		1:
			start_x = 0
			end_x = 188
		2:
			start_x = 188
			end_x = 250
		3:
			start_x = 250
			end_x = 313
		4:
			start_x = 313
			end_x = 375
		5:
			start_x = 375
			end_x = 438
		6:
			start_x = 438
			end_x = 500
		7:
			start_x = 500
			end_x = 563
		8:
			start_x = 563
			end_x = 625
		9:
			start_x = 625
			end_x = 688
		10:
			start_x = 688
			end_x = 750
		11:
			start_x = 750
			end_x = 813
		12:
			start_x = 813
			end_x = 1000
	match row:
		"A":
			start_y = 0
			end_y = 188
		"B":
			start_y = 188
			end_y = 250
		"C":
			start_y = 250
			end_y = 313
		"D":
			start_y = 313
			end_y = 375
		"E":
			start_y = 375
			end_y = 438
		"F":
			start_y = 438
			end_y = 500
		"G":
			start_y = 500
			end_y = 563
		"H":
			start_y = 563
			end_y = 625
		"I":
			start_y = 625
			end_y = 688
		"J":
			start_y = 688
			end_y = 750
		"K":
			start_y = 750
			end_y = 813
		"L":
			start_y = 813
			end_y = 1000
	plains.update_bitmask_region(Vector2(start_x, start_y),Vector2(end_x, end_y))
	#yield(get_tree(), "idle_frame")
	snow.update_bitmask_region(Vector2(start_x, start_y),Vector2(end_x, end_y))
	#yield(get_tree(), "idle_frame")
	forest.update_bitmask_region(Vector2(start_x, start_y),Vector2(end_x, end_y))
	#yield(get_tree(), "idle_frame")
	dirt.update_bitmask_region(Vector2(start_x, start_y),Vector2(end_x, end_y))
	#yield(get_tree(), "idle_frame")
	wetSand.update_bitmask_region(Vector2(start_x, start_y),Vector2(end_x, end_y))
	#yield(get_tree(), "idle_frame")
	waves.update_bitmask_region(Vector2(start_x, start_y),Vector2(end_x, end_y))
	#yield(get_tree(), "idle_frame")
	deep_ocean.update_bitmask_region(Vector2(start_x, start_y),Vector2(end_x, end_y))
