extends Node2D

var world = {}
var server_data = {}
var is_changing_scene = false


@onready var Player = load("res://World/Player/Player/Player.tscn")
@onready var CaveLight = load("res://World/Caves/Objects/CaveLight.tscn")


func _ready():
	Server.world = self
	initialize()
	await get_tree().create_timer(0.5).timeout
	spawn_player()
	$InitLoadingScreen.queue_free()

func spawn_player():
	var player = Player.instantiate()
	player.name = str("PLAYER") 
	player.load_screen_timer = 3.0
	$Players.add_child(player)
	var spawn_loc = $TerrainTiles/UpLadder.get_used_cells(0)[0]
	player.position = Vector2(spawn_loc*16) + Vector2(8,8)


func initialize():
	Tiles.cave_wall_tiles = $TerrainTiles/Walls
	Tiles.cave_water_tiles = $TerrainTiles/Freshwater
	if not PlayerData.player_data["skill_experience"]["wind"] == 0:
		$TerrainTiles/Doors.set_cell(0,Vector2i(37,13),0,Vector2i(48,11))
	if not PlayerData.player_data["skill_experience"]["fire"] == 0:
		$TerrainTiles/Doors.set_cell(0,Vector2i(45,16),0,Vector2i(48,11))
	for loc in $TerrainTiles/Lights.get_used_cells(0):
		var caveLight = CaveLight.instantiate()
		if $TerrainTiles/Lights.get_cell_atlas_coords(0,loc) == Vector2i(53,26): 
			caveLight.type = "red"
		elif $TerrainTiles/Lights.get_cell_atlas_coords(0,loc) == Vector2i(54,26): 
			caveLight.type = "yellow"
		elif $TerrainTiles/Lights.get_cell_atlas_coords(0,loc) == Vector2i(55,26): 
			caveLight.type = "blue"
		$LightObjects.add_child(caveLight)
		caveLight.position = loc*16 + Vector2i(8,8)
	add_cave_ladder_node()

func add_cave_ladder_node():
	var caveLadder = load("res://World/Caves/Objects/CaveLadder.tscn").instantiate()
	caveLadder.is_down_ladder = false
	caveLadder.position = Vector2($TerrainTiles/UpLadder.get_used_cells(0)[0]*16) + Vector2(8,0)
	call_deferred("add_child",caveLadder)


func _on_wind_cave_door_area_entered(area):
	Server.player_node.user_interface.get_node("DialogueBox").initialize("wind fae")

func _on_fire_cave_door_area_entered(area):
	if PlayerData.player_data["skill_experience"]["wind"] == 0:
		Server.player_node.user_interface.get_node("DialogueBox").initialize("locked fae")
	else:
		Server.player_node.user_interface.get_node("DialogueBox").initialize("fire fae")


func _on_ice_cave_door_area_entered(area):
	if PlayerData.player_data["skill_experience"]["fire"] == 0:
		Server.player_node.user_interface.get_node("DialogueBox").initialize("locked fae")
	else:
		Server.player_node.user_interface.get_node("DialogueBox").initialize("ice fae")
