extends Node2D

var world = {}
var server_data = {}
var is_changing_scene = false


@onready var Player = load("res://World/Player/Player/Player.tscn")
@onready var CaveLight = load("res://World/Caves/Objects/CaveLight.tscn")


func _ready():
	Server.world = self
	initialize()
	spawn_player()

func spawn_player():
	var player = Player.instantiate()
	player.name = str("PLAYER")
	$Players.add_child(player)
	var spawn_loc = $TerrainTiles/Ladder.get_used_cells(0)[0]
	player.position = spawn_loc*16


func initialize():
#	set_valid_tiles()
	set_cave_lights()


#func set_valid_tiles():
#	for x in range(60):
#		for y in range(30):
#			if $TerrainTiles/Walls.get_cell_atlas_coords(0,Vector2i(x,y)) == Vector2i(-1,-1) and $TerrainTiles/Freshwater.get_cell_atlas_coords(0,Vector2i(x,y)) == Vector2i(-1,-1):
#				$TerrainTiles/ValidTiles.set_cell(0,Vector2i(x,y),0,Constants.VALID_TILE_ATLAS_CORD)


func set_cave_lights():
	Tiles.cave_wall_tiles = $TerrainTiles/Walls
	Tiles.ocean_tiles = $TerrainTiles/Freshwater
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

@rpc
func send_server_data(data): 
	print("GOT SERVER DATA")
	server_data = data["server_data"]
