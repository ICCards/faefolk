extends Node
#
#@onready var dirt = get_node("../../GeneratedTiles/DirtTiles")
#@onready var plains = get_node("../../GeneratedTiles/GreenGrassTiles")
#@onready var forest = get_node("../../GeneratedTiles/DarkGreenGrassTiles")
##onready var water = $GeneratedTiles/Water
#@onready var validTiles = get_node("../../ValidTiles") 
#@onready var navTiles = get_node("../../Node2D/NavTiles")
#@onready var hoed = get_node("../../FarmingTiles/HoedAutoTiles")
#@onready var watered = get_node("../../FarmingTiles/WateredAutoTiles")
#@onready var snow = get_node("../../GeneratedTiles/SnowTiles")
#@onready var waves = get_node("../../GeneratedTiles/WaveTiles")
#@onready var wetSand = get_node("../../GeneratedTiles/WetSandBeachBorder")
#@onready var sand = get_node("../../GeneratedTiles/DrySandTiles")
#@onready var shallow_ocean = get_node("../../GeneratedTiles/ShallowOcean")
#@onready var deep_ocean = get_node("../../GeneratedTiles/DeepOcean")
#@onready var top_ocean = get_node("../../GeneratedTiles/TopOcean")
#
#
#var terrain_thread := Thread.new()
#
#var built_chunks = []
#var current_chunks = []
#
#@onready var IcPuppy = preload("res://World/Player/Pet/IcPuppy.tscn")
#
#var spawn_loc
#
#var game_state: GameState
#
#func initialize():
#	$BuildTerrainTimer.start()
#
#func _on_BuildTerrain_timeout():
#	build_terrain()
#
#func _whoAmI(chunk):
#	call_deferred("spawn_chunk", chunk)
#
#func build_terrain():
#	if Server.player_node:
#		for new_chunk in get_parent().built_chunks:
#			if not built_chunks.has(new_chunk) and not terrain_thread.is_alive():
#				built_chunks.append(new_chunk)
#				terrain_thread.start(Callable(self,"_whoAmI").bind(new_chunk))
#
#func spawn_chunk(chunk_name):
#	var _chunk = MapData.return_chunk(chunk_name[0],chunk_name.substr(1,-1))
#	if _chunk["plains"].size() > 0:
#		for loc_string in _chunk["plains"]:
#			var loc = Util.string_to_vector2(loc_string)
#			plains.set_cellv(loc, 0)
#		await get_tree().idle_frame
#	if _chunk["snow"].size() > 0:
#		for loc_string in _chunk["snow"]:
#			var loc = Util.string_to_vector2(loc_string)
#			snow.set_cellv(loc, 0)
#		await get_tree().idle_frame
#	if _chunk["forest"].size() > 0:
#		for loc_string in _chunk["forest"]:
#			var loc = Util.string_to_vector2(loc_string)
#			forest.set_cellv(loc, 0)
#		await get_tree().idle_frame
#	if _chunk["beach"].size() > 0:
#		for loc_string in _chunk["beach"]:
#			var loc = Util.string_to_vector2(loc_string)
#			Tiles._set_cell(sand, loc.x, loc.y, 0)
#		await get_tree().idle_frame
#	if _chunk["desert"].size() > 0:
#		for loc_string in _chunk["desert"]:
#			var loc = Util.string_to_vector2(loc_string)
#			Tiles._set_cell(sand, loc.x, loc.y, 0)
#		await get_tree().idle_frame
#	if _chunk["dirt"].size() > 0:
#		for loc_string in _chunk["dirt"]:
#			var loc = Util.string_to_vector2(loc_string)
#			dirt.set_cellv(loc, 0)
#		await get_tree().idle_frame
#	if _chunk["ocean"].size() > 0:
#		for loc_string in _chunk["ocean"]:
#			var loc = Util.string_to_vector2(loc_string)
#			if sand.get_cellv(loc) == -1:
#				wetSand.set_cellv(loc, 0)
#				waves.set_cellv(loc, 5)
#				shallow_ocean.set_cellv(loc, 0)
#				top_ocean.set_cellv(loc, 0)
#				deep_ocean.set_cellv(loc, 0)
#				validTiles.set_cellv(loc, -1)
#		await get_tree().idle_frame
#	for loc_string in _chunk["beach"]:
#		var loc = Util.string_to_vector2(loc_string)
#		#Tiles._set_cell(sand, loc.x, loc.y, 0)
#		for i in range(4):
#			if sand.get_cellv(loc+Vector2(i,0)) != -1 or sand.get_cellv(loc+Vector2(-i,0)) != -1 or sand.get_cellv(loc+Vector2(0,i)) != -1 or sand.get_cellv(loc+Vector2(0,-i)) != -1:
#				shallow_ocean.set_cellv(loc+Vector2(i,0),-1)
#				top_ocean.set_cellv(loc+Vector2(i,0),-1)
#				deep_ocean.set_cellv(loc+Vector2(i,0),-1)
#				waves.set_cellv(loc+Vector2(i,0), -1)
#				shallow_ocean.set_cellv(loc+Vector2(-i,0),-1)
#				top_ocean.set_cellv(loc+Vector2(-i,0),-1)
#				deep_ocean.set_cellv(loc+Vector2(-i,0),-1)
#				waves.set_cellv(loc+Vector2(-i,0), -1)
#				shallow_ocean.set_cellv(loc+Vector2(0,i),-1)
#				top_ocean.set_cellv(loc+Vector2(0,i),-1)
#				deep_ocean.set_cellv(loc+Vector2(0,i),-1)
#				waves.set_cellv(loc+Vector2(0,i), -1)
#				shallow_ocean.set_cellv(loc+Vector2(0,-i),-1)
#				top_ocean.set_cellv(loc+Vector2(0,-i),-1)
#				deep_ocean.set_cellv(loc+Vector2(0,-i),-1)
#				waves.set_cellv(loc+Vector2(0,-i), -1)
#		for i in range(4):
#			i += 4
#			if sand.get_cellv(loc+Vector2(i,0)) != -1 or sand.get_cellv(loc+Vector2(-i,0)) != -1 or \
#			sand.get_cellv(loc+Vector2(0,i)) != -1 or sand.get_cellv(loc+Vector2(0,-i)) != -1 or \
#			sand.get_cellv(loc+Vector2(i,i)) != -1 or sand.get_cellv(loc+Vector2(-i,i)) != -1 or \
#			sand.get_cellv(loc+Vector2(i,-i)) != -1 or sand.get_cellv(loc+Vector2(-i,-i)) != -1:
#				deep_ocean.set_cellv(loc+Vector2(i,0),-1)
#				deep_ocean.set_cellv(loc+Vector2(-i,0),-1)
#				deep_ocean.set_cellv(loc+Vector2(0,i),-1)
#				deep_ocean.set_cellv(loc+Vector2(0,-i),-1)
#	await get_tree().idle_frame
#	call_deferred("update_bitmasks", chunk_name)
#
#func update_bitmasks(chunk_name):
#	var _chunk = MapData.return_chunk(chunk_name[0],chunk_name.substr(1,-1))
#	var row = chunk_name[0]
#	var column = int(chunk_name.substr(1, -1))
#	var start_x
#	var start_y
#	var end_x
#	var end_y
#	match column:
#		1:
#			start_x = 0
#			end_x = 188
#		2:
#			start_x = 188
#			end_x = 250
#		3:
#			start_x = 250
#			end_x = 313
#		4:
#			start_x = 313
#			end_x = 375
#		5:
#			start_x = 375
#			end_x = 438
#		6:
#			start_x = 438
#			end_x = 500
#		7:
#			start_x = 500
#			end_x = 563
#		8:
#			start_x = 563
#			end_x = 625
#		9:
#			start_x = 625
#			end_x = 688
#		10:
#			start_x = 688
#			end_x = 750
#		11:
#			start_x = 750
#			end_x = 813
#		12:
#			start_x = 813
#			end_x = 1000
#	match row:
#		"A":
#			start_y = 0
#			end_y = 188
#		"B":
#			start_y = 188
#			end_y = 250
#		"C":
#			start_y = 250
#			end_y = 313
#		"D":
#			start_y = 313
#			end_y = 375
#		"E":
#			start_y = 375
#			end_y = 438
#		"F":
#			start_y = 438
#			end_y = 500
#		"G":
#			start_y = 500
#			end_y = 563
#		"H":
#			start_y = 563
#			end_y = 625
#		"I":
#			start_y = 625
#			end_y = 688
#		"J":
#			start_y = 688
#			end_y = 750
#		"K":
#			start_y = 750
#			end_y = 813
#		"L":
#			start_y = 813
#			end_y = 1000
#	if _chunk["plains"].size() > 0:
#		plains.call_deferred("update_bitmask_region", Vector2(start_x, start_y),Vector2(end_x, end_y))
#		await get_tree().idle_frame
#	if _chunk["snow"].size() > 0:
#		snow.call_deferred("update_bitmask_region", Vector2(start_x, start_y),Vector2(end_x, end_y))
#		await get_tree().idle_frame
#	if _chunk["forest"].size() > 0:
#		forest.call_deferred("update_bitmask_region", Vector2(start_x, start_y),Vector2(end_x, end_y))
#		await get_tree().idle_frame
#	if _chunk["dirt"].size() > 0:
#		dirt.call_deferred("update_bitmask_region", Vector2(start_x, start_y),Vector2(end_x, end_y))
#		await get_tree().idle_frame
#	if _chunk["ocean"].size() > 0:
#		wetSand.call_deferred("update_bitmask_region", Vector2(start_x, start_y),Vector2(end_x, end_y))
#		await get_tree().idle_frame
#		waves.call_deferred("update_bitmask_region", Vector2(start_x, start_y),Vector2(end_x, end_y))
#		await get_tree().idle_frame
#		deep_ocean.call_deferred("update_bitmask_region", Vector2(start_x, start_y),Vector2(end_x, end_y))
#		await get_tree().idle_frame
##	plains.call_deferred("update_bitmask_region", Vector2(start_x, start_y),Vector2(end_x, end_y))
##	await get_tree().idle_frame
##	await get_tree().idle_frame
##	snow.update_bitmask_region(Vector2(start_x, start_y),Vector2(end_x, end_y))
##	await get_tree().idle_frame
##	forest.update_bitmask_region(Vector2(start_x, start_y),Vector2(end_x, end_y))
##	await get_tree().idle_frame
##	dirt.update_bitmask_region(Vector2(start_x, start_y),Vector2(end_x, end_y))
##	await get_tree().idle_frame
##	wetSand.update_bitmask_region(Vector2(start_x, start_y),Vector2(end_x, end_y))
##	await get_tree().idle_frame
##	waves.update_bitmask_region(Vector2(start_x, start_y),Vector2(end_x, end_y))
##	await get_tree().idle_frame
##	deep_ocean.update_bitmask_region(Vector2(start_x, start_y),Vector2(end_x, end_y))
##	await get_tree().idle_frame
#	#print("BUILT TERRAIN " + str(chunk_name))
#	terrain_thread.wait_to_finish()


func _on_build_terrain_timer_timeout():
	pass # Replace with function body.
