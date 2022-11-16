extends YSort


onready var Bat = preload("res://World/Enemies/Slime/Bat.tscn")

var nav_node
var bat_count = 0
var maximum_bats = 6
var cave_chest_id = "level 1, room 4"

func _ready():
	nav_node = $Navigation2D
	Tiles.cave_wall_tiles = $Tiles/Walls
	Tiles.valid_tiles = $Tiles/ValidTiles
	Server.world = self
	BuildCaveLevel.build()
	Server.isLoaded = true

func advance_cave_level():
	SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 5/Cave 5.tscn")
	
func _on_SpawnBatTimer_timeout():
	if bat_count < maximum_bats:
		var locs = $Tiles/BatSpawnTiles.get_used_cells()
		locs.shuffle()
		var bat = Bat.instance()
		$Enemies.add_child(bat)
		bat.position = locs[0]*32
		bat_count += 1
