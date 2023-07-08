extends Node2D

var is_changing_scene = false

@onready var Player = load("res://World/Player/Player/Player.tscn")
@onready var CaveLight = load("res://World/Caves/Objects/CaveLight.tscn")


func _ready():
	Server.world = self
	initialize()
	set_navigation_tiles()
	await get_tree().create_timer(0.5).timeout
	spawn_player()
	$InitLoadingScreen.queue_free()


func set_navigation_tiles():
	for x in range(100):
		for y in range(70):
			if not $TerrainTiles/Walls.get_used_cells(0).has(Vector2i(x,y)):
				$TerrainTiles/NavigationTiles.set_cell(0,Vector2i(x,y),0,Vector2i(0,0))

func spawn_player():
	var player = Player.instantiate()
	player.name = str("PLAYER") 
	player.load_screen_timer = 1.0
	$Players.add_child(player)
	var spawn_loc = $TerrainTiles/UpLadder.get_used_cells(0)[0]
	player.position = Vector2(spawn_loc*16) + Vector2(8,8)

func initialize():
	Tiles.nav_tiles = $TerrainTiles/NavigationTiles
	Tiles.cave_wall_tiles = $TerrainTiles/Walls
	Tiles.cave_water_tiles = $TerrainTiles/Freshwater
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

