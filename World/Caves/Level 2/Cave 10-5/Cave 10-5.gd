extends YSort

var is_changing_scene: bool = false
var cave_chest_id = "level 1, room 10-5"

var NUM_BATS = 0
var NUM_SLIMES = 0
var NUM_SPIDERS = 0
var NUM_SKELETONS = 0
var map_size = 50

func _ready():
	randomize()
#	Tiles.cave_wall_tiles = $Tiles/Walls
#	Tiles.valid_tiles = $Tiles/ValidTiles
#	Tiles.ocean_tiles = $Tiles/Water
	Server.world = self
	BuildCaveLevel.build()
	Server.isLoaded = true

func advance_up_cave_level():
	if not is_changing_scene:
		BuildCaveLevel.is_player_going_down = false
		Server.player_node.destroy()
		is_changing_scene = true
		for enemy in $Enemies.get_children():
			enemy.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 10/Cave 10.tscn")

func advance_down_cave_level():
	if not is_changing_scene:
		BuildCaveLevel.is_player_going_down = true
		Server.player_node.destroy()
		is_changing_scene = true
		for enemy in $Enemies.get_children():
			enemy.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 2/Cave 11/Cave 11.tscn")



